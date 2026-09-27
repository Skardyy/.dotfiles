local M = {}

local RIFT = "/opt/homebrew/bin/rift-cli"

local function runJson(args, onResult)
  hs.task.new(RIFT, function(_, stdout)
    if not stdout or stdout == "" then
      if onResult then onResult(nil) end
      return
    end
    local ok, decoded = pcall(hs.json.decode, stdout)
    if onResult then onResult(ok and decoded or nil) end
  end, args):start()
end

-- Fetch normalized model (same shape as aerospace source).
--
-- rift-cli query displays returns:
--   [ { uuid, name, screen_id, frame, space, is_active_space, active_space_ids, ... } ]
-- rift-cli query workspaces --display <uuid> returns:
--   [ { id, index, name, layout_mode, is_active, window_count, windows[] } ]
-- rift-cli query windows --display <uuid> returns:
--   [ { id, title, is_focused, bundle_id, app_name, ... } ]
--
-- We treat rift's display uuid as monitor id/name.
function M.fetch(cb)
  runJson({ "query", "displays" }, function(displays)
    displays = displays or {}
    if #displays == 0 then
      cb({ monitors = {}, workspaces = {}, windows = {}, focused_window_id = nil })
      return
    end

    local monitors = {}
    for _, d in ipairs(displays) do
      monitors[#monitors + 1] = { id = d.uuid, name = d.name or d.uuid }
    end

    local pending = #displays * 2
    local ws_out, win_out = {}, {}
    local focused_window_id = nil

    local function done()
      pending = pending - 1
      if pending == 0 then
        cb({
          monitors = monitors,
          workspaces = ws_out,
          windows = win_out,
          focused_window_id = focused_window_id,
        })
      end
    end

    for _, d in ipairs(displays) do
      local uuid = d.uuid
      runJson({ "query", "workspaces", "--display", uuid }, function(wss)
        for _, ws in ipairs(wss or {}) do
          ws_out[#ws_out + 1] = {
            workspace = tostring(ws.index + 1),
            monitor_id = uuid,
            visible = ws.is_active,
          }
          for _, w in ipairs(ws.windows or {}) do
            win_out[#win_out + 1] = {
              id = tostring(w.id.pid or w.id) .. ":" .. tostring(w.id.idx or ""),
              bundle = w.bundle_id,
              name = w.app_name or "",
              workspace = tostring(ws.index + 1),
              monitor_id = uuid,
            }
            if w.is_focused then
              focused_window_id = tostring(w.id.pid or w.id) .. ":" .. tostring(w.id.idx or "")
            end
          end
        end
        done()
      end)
      runJson({ "query", "windows", "--display", uuid }, function(_)
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

-- Rift's workspace switches don't fire hs.window.filter events. Stream
-- rift's mach event bus so the bar refreshes the moment WM state changes.
-- hs.task.new signature: (path, exitCallback, streamCallback, args).
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
