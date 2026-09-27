-- macOS enables click-and-drag anywhere on a window body only with ctrl+cmd
-- (NSWindowShouldDragOnGesture). This tap adds the ctrl flag transparently
-- while cmd is held on mouse events so plain cmd+drag activates the OS
-- window-drag, which aerospace then observes via AXWindowMoved.
--
-- Requires: `defaults write -g NSWindowShouldDragOnGesture -bool true`.

local M = {}

local function addCtrl(event)
  local flags = event:getFlags()
  if flags.cmd and not flags.ctrl then
    flags.ctrl = true
    event:setFlags(flags)
  end
  return false, { event }
end

function M.start()
  M.tap = hs.eventtap.new({
    hs.eventtap.event.types.leftMouseDown,
    hs.eventtap.event.types.leftMouseDragged,
    hs.eventtap.event.types.leftMouseUp,
  }, addCtrl)
  M.tap:start()
end

return M
