hs.autoLaunch(false)
hs.menuIcon(false)

require("cpu")
require("macos_spaces")

local cmd = { "cmd" }
local cmdShift = { "cmd", "shift" }

local YABAI = "/opt/homebrew/bin/yabai"

local function yabai(args, fallback)
  hs.task.new(YABAI, function(exitCode)
    if exitCode ~= 0 and fallback then
      hs.task.new(YABAI, nil, fallback):start()
    end
  end, args):start()
end

-- ====================
-- Apps
-- ====================
hs.hotkey.bind(cmd, "return", function()
  hs.task.new("/usr/bin/open", nil, { "-na", "Ghostty" }):start()
end)

hs.hotkey.bind(cmd, "w", function()
  hs.application.launchOrFocus("Zen Browser (Beta)")
end)

hs.hotkey.bind(cmd, "s", function()
  hs.task.new("/usr/sbin/screencapture", nil, { "-ic" }):start()
end)

hs.hotkey.bind(cmdShift, "c", function()
  hs.task.new("/usr/bin/open", nil, { "-g", "raycast://extensions/thomas/color-picker/pick-color" }):start()
end)

hs.hotkey.bind(cmdShift, "v", function()
  hs.task.new("/usr/bin/open", nil, { "-g", "raycast://extensions/raycast/clipboard-history/clipboard-history" }):start()
end)

-- ====================
-- Focus (h/j/k/l)
-- ====================
hs.hotkey.bind(cmd, "h",
  function() yabai({ "-m", "window", "--focus", "west" }, { "-m", "display", "--focus", "west" }) end)
hs.hotkey.bind(cmd, "j",
  function() yabai({ "-m", "window", "--focus", "south" }, { "-m", "display", "--focus", "south" }) end)
hs.hotkey.bind(cmd, "k",
  function() yabai({ "-m", "window", "--focus", "north" }, { "-m", "display", "--focus", "north" }) end)
hs.hotkey.bind(cmd, "l",
  function() yabai({ "-m", "window", "--focus", "east" }, { "-m", "display", "--focus", "east" }) end)

-- ====================
-- Move (h/j/k/l)
-- ====================
hs.hotkey.bind(cmdShift, "h",
  function() yabai({ "-m", "window", "--swap", "west" }, { "-m", "window", "--display", "west" }) end)
hs.hotkey.bind(cmdShift, "j",
  function() yabai({ "-m", "window", "--swap", "south" }, { "-m", "window", "--display", "south" }) end)
hs.hotkey.bind(cmdShift, "k",
  function() yabai({ "-m", "window", "--swap", "north" }, { "-m", "window", "--display", "north" }) end)
hs.hotkey.bind(cmdShift, "l",
  function() yabai({ "-m", "window", "--swap", "east" }, { "-m", "window", "--display", "east" }) end)

-- ====================
-- Switch to space
-- ====================
for i = 1, 9 do
  hs.hotkey.bind(cmd, tostring(i), function()
    yabai({ "-m", "space", "--focus", tostring(i) })
  end)
end

-- ====================
-- Move window to space
-- ====================
for i = 1, 9 do
  hs.hotkey.bind(cmdShift, tostring(i), function()
    yabai({ "-m", "window", "--space", tostring(i) })
  end)
end

-- ====================
-- Reload
-- ====================
hs.hotkey.bind(cmdShift, "r", function()
  local uid = hs.execute("id -u"):gsub("%s+$", "")
  hs.task.new("/bin/launchctl", function()
    hs.reload()
  end, { "kickstart", "-k", "gui/" .. uid .. "/org.nixos.yabai" }):start()
end)

hs.alert.show("Hammerspoon loaded")
