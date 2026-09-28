local Exec = {}

---@param bin string
---@param args string[]
---@param cb fun(decoded: any?)
function Exec.runJson(bin, args, cb)
  hs.task.new(bin, function(_, stdout)
    if not stdout or stdout == "" then
      cb(nil); return
    end
    local ok, decoded = pcall(hs.json.decode, stdout)
    cb(ok and decoded or nil)
  end, args):start()
end

---@param specs table<string, string[]>
---@param bin string
---@param cb fun(results: table<string, any>)
function Exec.batchJson(bin, specs, cb)
  local pending = 0
  for _ in pairs(specs) do pending = pending + 1 end
  local results = {}
  local function finish(key, value)
    results[key] = value
    pending = pending - 1
    if pending == 0 then cb(results) end
  end
  for key, args in pairs(specs) do
    Exec.runJson(bin, args, function(d) finish(key, d) end)
  end
end

return Exec
