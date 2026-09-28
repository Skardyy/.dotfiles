local M = {}

local AEROSPACE = "/opt/homebrew/bin/aerospace"

local function run(args, onResult)
  hs.task.new(AEROSPACE, function(_, stdout)
    if not stdout or stdout == "" then
      if onResult then onResult(nil) end
      return
    end
    local ok, decoded = pcall(hs.json.decode, stdout)
    if onResult then onResult(ok and decoded or nil) end
  end, args):start()
end

local function batch(specs, onDone)
  local pending = 0
  for _ in pairs(specs) do pending = pending + 1 end
  local results = {}
  local function finish(key, value)
    results[key] = value
    pending = pending - 1
    if pending == 0 then onDone(results) end
  end
  for key, args in pairs(specs) do
    run(args, function(d) finish(key, d) end)
  end
end

-- Returns the aerospace-managed slice of the desktop:
--   { monitors           = { { id, name } },
--     workspaces         = { { workspace, monitor_id, visible } },
--     windows            = { { id, bundle, name, workspace, monitor_id, hidden = false } },
--     focused_window_id  = <id> or nil }
function M.fetch(cb)
  batch({
    monitors = { "list-monitors", "--json",
      "--format", "%{monitor-id}%{monitor-name}" },
    workspaces = { "list-workspaces", "--all", "--json",
      "--format", "%{workspace}%{monitor-id}%{workspace-is-visible}" },
    windows = { "list-windows", "--all", "--json",
      "--format", "%{window-id}%{app-name}%{app-bundle-id}%{workspace}%{monitor-id}" },
    focused = { "list-windows", "--focused", "--json",
      "--format", "%{window-id}" },
  }, function(r)
    local monitors = {}
    for _, m in ipairs(r.monitors or {}) do
      monitors[#monitors + 1] = { id = m["monitor-id"], name = m["monitor-name"] }
    end
    local workspaces = {}
    for _, w in ipairs(r.workspaces or {}) do
      workspaces[#workspaces + 1] = {
        workspace = w["workspace"],
        monitor_id = w["monitor-id"],
        visible = w["workspace-is-visible"],
      }
    end
    local windows = {}
    for _, w in ipairs(r.windows or {}) do
      windows[#windows + 1] = {
        id = w["window-id"],
        bundle = w["app-bundle-id"],
        name = w["app-name"] or "",
        workspace = w["workspace"],
        monitor_id = w["monitor-id"],
        hidden = false,
      }
    end

    local focused_window_id = r.focused and r.focused[1] and r.focused[1]["window-id"] or nil
    cb({
      monitors = monitors,
      workspaces = workspaces,
      windows = windows,
      focused_window_id = focused_window_id,
    })
  end)
end

function M.switch_workspace(name)
  hs.task.new(AEROSPACE, nil, { "workspace", tostring(name) }):start()
end

return M
