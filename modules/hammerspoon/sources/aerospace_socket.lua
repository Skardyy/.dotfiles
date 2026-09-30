-- Persistent connection to the aerospace unix socket. Wire protocol from
-- github.com/nikitabobko/AeroSpace Sources/Common/util/NWConnectionEx.swift:
--   handshake: [u32 LE 1] both ways
--   request:   [u32 LE len][utf-8 JSON: {"args":[...],"stdin":"","windowId":null,"workspace":null}]
--   response:  [u32 LE len][utf-8 JSON: {"exitCode","stdout","stderr",...}]
-- Requests are pipelined FIFO; the server responds in order.

local Socket = {}

local socketPath = "/tmp/bobko.aerospace-" .. (os.getenv("USER") or "") .. ".sock"

local sock = nil
local ready = false
local pending = {}
local queuedRequests = {}

local function onRead(data, tag)
  if tag == 1 then
    if #data == 4 and string.unpack("<I4", data) == 1 then
      ready = true
      sock:read(4, 2)
      while #queuedRequests > 0 do
        local q = table.remove(queuedRequests, 1)
        sock:write(q)
      end
    else
      print("aerospace socket: handshake mismatch")
    end
    return
  end
  if tag == 2 then
    if #data ~= 4 then return end
    sock:read(string.unpack("<I4", data), 3)
    return
  end
  if tag == 3 then
    local cb = table.remove(pending, 1)
    if cb then
      local ok, decoded = pcall(hs.json.decode, data)
      cb(ok and decoded or nil)
    end
    sock:read(4, 2)
    return
  end
end

local function ensureConnected()
  if sock then return end
  sock = hs.socket.new(onRead)
  sock:connect(socketPath, function()
    sock:write(string.pack("<I4", 1))
    sock:read(4, 1)
  end)
end

---@param args string[]
---@param cb fun(response: any?)
function Socket.request(args, cb)
  ensureConnected()
  local argsJson = hs.json.encode(args)
  local payload = '{"args":' .. argsJson .. ',"stdin":"","windowId":null,"workspace":null}'
  local frame = string.pack("<I4", #payload) .. payload
  pending[#pending + 1] = cb
  if ready then
    sock:write(frame)
  else
    queuedRequests[#queuedRequests + 1] = frame
  end
end

---@param args string[]
---@param cb fun(decoded: any?)
function Socket.requestJson(args, cb)
  Socket.request(args, function(resp)
    if not resp or resp.exitCode ~= 0 or not resp.stdout or resp.stdout == "" then
      cb(nil)
      return
    end
    local ok, decoded = pcall(hs.json.decode, resp.stdout)
    cb(ok and decoded or nil)
  end)
end

---@param specs table<string, string[]>
---@param cb fun(results: table<string, any>)
function Socket.batchJson(specs, cb)
  local pending_count = 0
  for _ in pairs(specs) do pending_count = pending_count + 1 end
  local results = {}
  local function finish(key, value)
    results[key] = value
    pending_count = pending_count - 1
    if pending_count == 0 then cb(results) end
  end
  for key, args in pairs(specs) do
    Socket.requestJson(args, function(d) finish(key, d) end)
  end
end

return Socket
