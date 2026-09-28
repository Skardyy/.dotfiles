local cfg = require("workspace_bar.config")

local Workspace = {}

---@param opts { id: string|integer, visible: boolean?, windows: Window[]? }
---@return Workspace
function Workspace.new(opts)
  return {
    id = opts.id,
    visible = opts.visible or false,
    windows = opts.windows or {},
  }
end

---@param id string|integer
---@return boolean
function Workspace.isScratch(id)
  local n = tonumber(id)
  return n and n >= cfg.SCRATCH_THRESHOLD or false
end

---@param id string|integer
---@return string
function Workspace.labelFor(id)
  if id == cfg.HIDDEN_WORKSPACE_ID then return cfg.HIDDEN_BADGE_TEXT end
  if Workspace.isScratch(id) then return "~" end
  return tostring(id)
end

---@param ws Workspace
---@return boolean
function Workspace.isHidden(ws)
  return ws.id == cfg.HIDDEN_WORKSPACE_ID
end

return Workspace
