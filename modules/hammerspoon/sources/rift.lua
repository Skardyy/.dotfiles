local Exec = require("workspace_bar.exec")
local Window = require("workspace_bar.window")
local Workspace = require("workspace_bar.workspace")
local Screen = require("workspace_bar.screen")

local M = {}

local RIFT = "/opt/homebrew/bin/rift-cli"

local function windowKey(id)
  return tostring(id.pid or id) .. ":" .. tostring(id.idx or "")
end

---@param cb fun(snapshot: WMSnapshot?)
function M.fetch(cb)
  Exec.runJson(RIFT, { "query", "displays" }, function(displays)
    displays = displays or {}
    if #displays == 0 then
      cb({ screens = {}, focused_window_id = nil })
      return
    end

    local screens = {}
    local screensByUuid = {}
    for _, d in ipairs(displays) do
      local s = Screen.new({ id = d.uuid, name = d.name })
      screens[#screens + 1] = s
      screensByUuid[d.uuid] = s
    end

    local pending = #displays
    local focused_window_id = nil

    local function done()
      pending = pending - 1
      if pending == 0 then
        cb({ screens = screens, focused_window_id = focused_window_id })
      end
    end

    for _, d in ipairs(displays) do
      local uuid = d.uuid
      Exec.runJson(RIFT, { "query", "workspaces", "--display", uuid }, function(wss)
        local screen = screensByUuid[uuid]
        for _, ws in ipairs(wss or {}) do
          local wsId = tostring(ws.index + 1)
          local wins = {}
          for _, w in ipairs(ws.windows or {}) do
            local wid = windowKey(w.id)
            wins[#wins + 1] = Window.new({
              id = wid,
              bundle = w.bundle_id,
              name = w.app_name,
            })
            if w.is_focused then focused_window_id = wid end
          end
          local workspace = Workspace.new({
            id = wsId,
            visible = ws.is_active,
            windows = wins,
          })
          table.insert(screen.workspaces, workspace)
          if workspace.visible then screen.focused = workspace.id end
        end
        done()
      end)
    end
  end)
end

function M.switch_workspace(name)
  local idx = tonumber(name)
  local arg = idx and tostring(idx - 1) or tostring(name)
  hs.task.new(RIFT, nil, { "execute", "workspace", "switch", arg }):start()
end

function M.subscribe(on_change)
  local task
  local function spawn()
    task = hs.task.new(
      RIFT,
      function() hs.timer.doAfter(1.0, spawn) end,
      function(_, stdout, _)
        if stdout and stdout ~= "" then on_change() end
        return true
      end,
      { "subscribe", "mach", "*" }
    )
    task:setStreamingCallback(function(_, stdout, _)
      if stdout and stdout ~= "" then on_change() end
      return true
    end)
    task:start()
  end
  spawn()
  return task
end

return M
