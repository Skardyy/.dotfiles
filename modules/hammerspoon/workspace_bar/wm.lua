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

---@param known table<any, boolean>
---@return Window[]
local function discoverHiddenWindows(known)
  local out = {}
  for _, hw in ipairs(hs.window.allWindows()) do
    local wid = hw:id()
    if wid and not known[wid] then
      local app = hw:application()
      local bundle = app and app:bundleID()
      local minimized = hw:isMinimized()
      local appHidden = app and app:isHidden() or false
      if bundle and (minimized or appHidden) then
        out[#out + 1] = Window.new({
          id = wid,
          bundle = bundle,
          name = app and app:name() or "",
          hidden = true,
        })
      end
    end
  end
  return out
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

---@param snapshot WMSnapshot
---@return table<string, Screen>  keyed by hs.screen UUID
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

  local xByWinId = {}
  for _, hw in ipairs(hs.window.allWindows()) do
    local id = hw:id()
    if id then
      local f = hw:frame()
      if f then xByWinId[id] = f.x end
    end
  end

  for _, s in ipairs(snapshot.screens) do
    for _, ws in ipairs(s.workspaces) do
      table.sort(ws.windows, function(a, b)
        local ax = xByWinId[a.id] or math.huge
        local bx = xByWinId[b.id] or math.huge
        if ax ~= bx then return ax < bx end
        return tostring(a.id) < tostring(b.id)
      end)
    end
  end

  local hidden = discoverHiddenWindows(known)
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

---@param cb fun(screens: table<string, Screen>, focusedWindowId: (integer|string)?)
function WM.fetch(cb)
  if not source then return end
  source.fetch(function(snapshot)
    if not snapshot then return end
    cb(arrange(snapshot), snapshot.focused_window_id)
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
