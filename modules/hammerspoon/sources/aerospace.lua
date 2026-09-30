local Socket = require("sources.aerospace_socket")
local Window = require("workspace_bar.window")
local Workspace = require("workspace_bar.workspace")
local Screen = require("workspace_bar.screen")

local M = {}

local AEROSPACE = "/opt/homebrew/bin/aerospace"

---@param cb fun(snapshot: WMSnapshot?)
function M.fetch(cb)
  Socket.batchJson({
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
-- streamed on stdout is a JSON ServerEvent. Auto-respawns on unexpected
-- exit. The event kind (`_event` field) is passed to the callback so the
-- caller can decide whether the event may have changed tree shape.
---@param onEvent fun(kind: string?)
---@return hs.task
function M.subscribe(onEvent)
  local task
  local buffer = ""
  local function spawn()
    task = hs.task.new(
      AEROSPACE,
      function() hs.timer.doAfter(1.0, spawn) end,
      function(_, stdout, _)
        if not stdout or stdout == "" then return true end
        buffer = buffer .. stdout
        while true do
          local nl = buffer:find("\n", 1, true)
          if not nl then break end
          local line = buffer:sub(1, nl - 1)
          buffer = buffer:sub(nl + 1)
          local kind = line:match('"_event"%s*:%s*"([^"]+)"')
          onEvent(kind)
        end
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
