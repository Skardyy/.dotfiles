local Screen = {}

---@param opts { id: integer|string, name: string?, workspaces: Workspace[]?, focused: (string|integer)? }
---@return Screen
function Screen.new(opts)
  return {
    id = opts.id,
    name = opts.name or tostring(opts.id),
    workspaces = opts.workspaces or {},
    focused = opts.focused,
  }
end

return Screen
