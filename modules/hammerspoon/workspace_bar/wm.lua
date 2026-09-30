local cfg = require("workspace_bar.config")
local Workspace = require("workspace_bar.workspace")
local Window = require("workspace_bar.window")

local WM = {}

local source = nil

---@param name string
function WM.load(name)
  source = require("sources." .. name)
end

---@param hs_screen hs.screen
---@return number
function WM.menubarHeight(hs_screen)
  return hs_screen:frame().y - hs_screen:fullFrame().y
end

---@param hs_screen hs.screen
---@return boolean
function WM.hasNotch(hs_screen)
  return WM.menubarHeight(hs_screen) > cfg.NOTCH_THRESHOLD
end

local function workspaceSortKey(ws)
  local sid = tostring(ws.id)
  local n = tonumber(sid)
  if n then
    if Workspace.isScratch(sid) then return string.format("z%020d", n) end
    return string.format("a%020d", n)
  end
  return "y" .. sid
end

-- Cheap fingerprint of a raw snapshot. If two consecutive fetches produce
-- the same fingerprint, callers can skip re-running arrange + repaint.
---@param snapshot WMSnapshot
---@return string
local function snapshotFingerprint(snapshot)
  local parts = { tostring(snapshot.focused_window_id) }
  for _, s in ipairs(snapshot.screens) do
    parts[#parts + 1] = tostring(s.id) .. "@" .. tostring(s.focused)
    for _, ws in ipairs(s.workspaces) do
      parts[#parts + 1] = tostring(ws.id) .. (ws.visible and "V" or "")
      for _, w in ipairs(ws.windows) do
        parts[#parts + 1] = tostring(w.id)
      end
    end
  end
  return table.concat(parts, "|")
end

---@param snapshot WMSnapshot
---@return table<string, Screen>
local function arrange(snapshot)
  local hsByName, hsByIndex = {}, {}
  for i, hs_screen in ipairs(hs.screen.allScreens()) do
    hsByIndex[i] = hs_screen
    hsByName[hs_screen:name() or ""] = hs_screen
  end

  local hsByScreenId = {}
  for _, s in ipairs(snapshot.screens) do
    local match = hsByName[s.name or ""] or hsByIndex[s.id] or hs.screen.find(s.id)
    if match then hsByScreenId[s.id] = match end
  end

  local known = {}
  for _, s in ipairs(snapshot.screens) do
    for _, ws in ipairs(s.workspaces) do
      for _, w in ipairs(ws.windows) do
        if w.id then known[w.id] = true end
      end
    end
  end

  -- One AX pass: sort keys for known windows, hidden bucket entries for the
  -- rest. Merged so we do not enumerate all windows twice.
  local xByWinId = {}
  local hidden = {}
  for _, hw in ipairs(hs.window.allWindows()) do
    local id = hw:id()
    if id then
      if known[id] then
        local f = hw:frame()
        if f then xByWinId[id] = f.x end
      else
        local minimized = hw:isMinimized()
        local app = hw:application()
        local appHidden = app and app:isHidden() or false
        local bundle = app and app:bundleID()
        if bundle and (minimized or appHidden) then
          hidden[#hidden + 1] = Window.new({
            id = id,
            bundle = bundle,
            name = app and app:name() or "",
            hidden = true,
          })
        end
      end
    end
  end

  for _, s in ipairs(snapshot.screens) do
    for _, ws in ipairs(s.workspaces) do
      if #ws.windows > 1 then
        table.sort(ws.windows, function(a, b)
          local ax = xByWinId[a.id] or math.huge
          local bx = xByWinId[b.id] or math.huge
          if ax ~= bx then return ax < bx end
          return tostring(a.id) < tostring(b.id)
        end)
      end
    end
  end

  local primary = hs.screen.primaryScreen()
  local primaryScreenId
  for sid, hw in pairs(hsByScreenId) do
    if hw == primary then
      primaryScreenId = sid; break
    end
  end
  primaryScreenId = primaryScreenId or (snapshot.screens[1] and snapshot.screens[1].id)

  local out = {}
  for _, s in ipairs(snapshot.screens) do
    local list = {}
    for _, ws in ipairs(s.workspaces) do
      if #ws.windows > 0 or ws.visible then list[#list + 1] = ws end
    end
    if s.id == primaryScreenId and #hidden > 0 then
      list[#list + 1] = Workspace.new({
        id = cfg.HIDDEN_WORKSPACE_ID,
        visible = false,
        windows = hidden,
      })
    end
    table.sort(list, function(a, b) return workspaceSortKey(a) < workspaceSortKey(b) end)
    local hw = hsByScreenId[s.id]
    if hw then
      out[hw:getUUID()] = {
        id = s.id,
        name = s.name,
        workspaces = list,
        focused = s.focused,
      }
    end
  end
  return out
end

local lastFingerprint = nil
local lastResult = nil
local lastFocusedWindowId = nil

---@param cb fun(screens: table<string, Screen>, focusedWindowId: (integer|string)?, unchanged: boolean)
function WM.fetch(cb)
  if not source then return end
  source.fetch(function(snapshot)
    if not snapshot then return end
    local fp = snapshotFingerprint(snapshot)
    if fp == lastFingerprint and lastResult then
      cb(lastResult, lastFocusedWindowId, true)
      return
    end
    lastFingerprint = fp
    lastResult = arrange(snapshot)
    lastFocusedWindowId = snapshot.focused_window_id
    cb(lastResult, lastFocusedWindowId, false)
  end)
end

---@param name string|integer
function WM.switchWorkspace(name)
  if source and source.switch_workspace then
    source.switch_workspace(name)
  end
end

---@param onEvent fun()
---@return hs.task?
function WM.subscribe(onEvent)
  if source and source.subscribe then
    return source.subscribe(onEvent)
  end
  return nil
end

return WM
