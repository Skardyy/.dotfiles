local Window = require("workspace_bar.window")

-- Tracks which windows are currently minimized or belong to an app-hidden
-- app. State is seeded once by enumerating hs.window.allWindows(), then kept
-- in sync via hs.window.filter events. No time-based invalidation: every
-- change comes from a real macOS event.
local HiddenTracker = {}

---@type table<any, Window>
local set = {}
local filter = nil
local onChange = nil

---@param hw hs.window
local function reconsider(hw)
  if not hw then return end
  local id = hw:id()
  if not id then return end
  local app = hw:application()
  local bundle = app and app:bundleID()
  if not bundle then
    set[id] = nil
    return
  end
  local minimized = hw:isMinimized()
  local appHidden = app:isHidden()
  if minimized or appHidden then
    set[id] = Window.new({
      id = id,
      bundle = bundle,
      name = app:name() or "",
      hidden = true,
    })
  else
    set[id] = nil
  end
end

---@param cb fun() called after any tracked state change
function HiddenTracker.start(cb)
  onChange = cb
  set = {}
  for _, hw in ipairs(hs.window.allWindows()) do reconsider(hw) end

  filter = hs.window.filter.new(true)
  filter:subscribe({
    hs.window.filter.windowMinimized,
    hs.window.filter.windowUnminimized,
    hs.window.filter.windowHidden,
    hs.window.filter.windowUnhidden,
    hs.window.filter.windowCreated,
    hs.window.filter.windowDestroyed,
  }, function(hw, _, event)
    if event == hs.window.filter.windowDestroyed then
      if hw then
        local id = hw:id()
        if id then set[id] = nil end
      end
    else
      reconsider(hw)
    end
    if onChange then onChange() end
  end)
end

---@return Window[]
function HiddenTracker.list()
  local out = {}
  for _, w in pairs(set) do out[#out + 1] = w end
  return out
end

return HiddenTracker
