local Exec = require("workspace_bar.exec")
local Window = require("workspace_bar.window")
local Workspace = require("workspace_bar.workspace")
local Screen = require("workspace_bar.screen")

local M = {}

local AEROSPACE = "/opt/homebrew/bin/aerospace"

---@param cb fun(snapshot: WMSnapshot?)
function M.fetch(cb)
  Exec.batchJson(AEROSPACE, {
    monitors = { "list-monitors", "--json",
      "--format", "%{monitor-id}%{monitor-name}" },
    workspaces = { "list-workspaces", "--all", "--json",
      "--format", "%{workspace}%{monitor-id}%{workspace-is-visible}" },
    windows = { "list-windows", "--all", "--json",
      "--format", "%{window-id}%{app-name}%{app-bundle-id}%{workspace}%{monitor-id}%{workspace-root-container-layout}" },
    focused = { "list-windows", "--focused", "--json",
      "--format", "%{window-id}" },
  }, function(r)
    local screensById = {}
    local screens = {}
    for _, m in ipairs(r.monitors or {}) do
      local s = Screen.new({ id = m["monitor-id"], name = m["monitor-name"] })
      screensById[s.id] = s
      screens[#screens + 1] = s
    end

    local workspacesById = {}
    for _, w in ipairs(r.workspaces or {}) do
      local ws = Workspace.new({
        id = w["workspace"],
        visible = w["workspace-is-visible"],
      })
      workspacesById[ws.id] = ws
      local s = screensById[w["monitor-id"]]
      if s then
        table.insert(s.workspaces, ws)
        if ws.visible then s.focused = ws.id end
      end
    end

    for _, w in ipairs(r.windows or {}) do
      local ws = workspacesById[w["workspace"]]
      if ws then
        table.insert(ws.windows, Window.new({
          id = w["window-id"],
          bundle = w["app-bundle-id"],
          name = w["app-name"],
        }))
        local layout = w["workspace-root-container-layout"] or ""
        if layout:find("accordion") then ws.preserveOrder = true end
      end
    end

    local focused_window_id = r.focused and r.focused[1] and r.focused[1]["window-id"] or nil
    cb({ screens = screens, focused_window_id = focused_window_id })
  end)
end

function M.switch_workspace(name)
  hs.task.new(AEROSPACE, nil, { "workspace", tostring(name) }):start()
end

-- Long-lived subscription to aerospace's native event stream. Each line
-- streamed on stdout is a JSON ServerEvent; any event means the bar needs
-- to re-fetch. Auto-respawns on unexpected exit.
---@param onEvent fun()
---@return hs.task
function M.subscribe(onEvent)
  local task
  local function spawn()
    task = hs.task.new(
      AEROSPACE,
      function() hs.timer.doAfter(1.0, spawn) end,
      function(_, stdout, _)
        if stdout and stdout ~= "" then onEvent() end
        return true
      end,
      { "subscribe", "--all" }
    )
    task:start()
  end
  spawn()
  return task
end

return M
