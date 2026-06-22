hs.autoLaunch(false)
hs.menuIcon(false)

require("cpu")
require("macos_spaces")

local YABAI = "/opt/homebrew/bin/yabai"
local cmd = { "cmd" }
local cmdShift = { "cmd", "shift" }

-- === yabai helpers ===

-- Fire a yabai command async. onDone(exitCode, stdout, stderr) is optional.
local function run(args, onDone)
  hs.task.new(YABAI, onDone, args):start()
end

-- Fire a yabai query async. onResult is called with the parsed JSON.
local function query(args, onResult)
  run(args, function(_, stdout)
    if not stdout or stdout == "" then return end
    local ok, decoded = pcall(hs.json.decode, stdout)
    if ok and decoded then onResult(decoded) end
  end)
end

-- Async-resolve the yabai display under the cursor, then invoke fn with it.
local function withMouseDisplay(fn)
  local screen = hs.mouse.getCurrentScreen()
  if not screen then return end
  local uuid = screen:getUUID()

  query({ "-m", "query", "--displays" }, function(displays)
    for _, d in ipairs(displays) do
      if d.uuid == uuid then
        fn(d)
        return
      end
    end
  end)
end

-- Snap the cursor to the center of the currently focused window.
local function warpToFocusedWindow()
  query({ "-m", "query", "--windows", "--window" }, function(w)
    if not w.frame then return end
    hs.mouse.absolutePosition({
      x = w.frame.x + w.frame.w / 2,
      y = w.frame.y + w.frame.h / 2,
    })
  end)
end

-- === Apps ===

-- Focus the display under the cursor, then invoke launch so the new window spawns there.
local function launchOnMouseDisplay(launch)
  withMouseDisplay(function(d)
    run({ "-m", "display", "--focus", tostring(d.index) }, launch)
  end)
end

hs.hotkey.bind(cmd, "return", function()
  launchOnMouseDisplay(function()
    hs.task.new("/usr/bin/open", nil, { "-na", "Ghostty" }):start()
  end)
end)

hs.hotkey.bind(cmd, "w", function()
  launchOnMouseDisplay(function()
    hs.application.launchOrFocus("Zen Browser (Beta)")
  end)
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

-- === Focus (h/j/k/l) ===

local function focus(dir)
  return function()
    run({ "-m", "window", "--focus", dir }, function(ec)
      if ec == 0 then
        warpToFocusedWindow()
        return
      end

      run({ "-m", "display", "--focus", dir }, function(ec2)
        if ec2 == 0 then warpToFocusedWindow() end
      end)
    end)
  end
end

hs.hotkey.bind(cmd, "h", focus("west"))
hs.hotkey.bind(cmd, "j", focus("south"))
hs.hotkey.bind(cmd, "k", focus("north"))
hs.hotkey.bind(cmd, "l", focus("east"))

-- === Move (h/j/k/l) ===

local function swap(dir)
  return function()
    run({ "-m", "window", "--swap", dir }, function(ec)
      if ec == 0 then
        warpToFocusedWindow()
        return
      end

      run({ "-m", "window", "--display", dir }, function(ec2)
        if ec2 ~= 0 then return end

        -- Refocus the destination display so the cursor warp targets the moved window.
        run({ "-m", "display", "--focus", dir }, function() warpToFocusedWindow() end)
      end)
    end)
  end
end

hs.hotkey.bind(cmdShift, "h", swap("west"))
hs.hotkey.bind(cmdShift, "j", swap("south"))
hs.hotkey.bind(cmdShift, "k", swap("north"))
hs.hotkey.bind(cmdShift, "l", swap("east"))

-- === Spaces ===

for i = 1, 9 do
  hs.hotkey.bind(cmd, tostring(i), function()
    withMouseDisplay(function(d)
      local sid = d.spaces and d.spaces[i]
      if not sid then return end

      run({ "-m", "space", "--focus", tostring(sid) })
    end)
  end)

  hs.hotkey.bind(cmdShift, tostring(i), function()
    query({ "-m", "query", "--displays", "--display" }, function(d)
      local sid = d.spaces and d.spaces[i]
      if not sid then return end

      run({ "-m", "window", "--space", tostring(sid) })
    end)
  end)
end

-- === Reload ===

hs.hotkey.bind(cmdShift, "r", function()
  local uid = hs.execute("id -u"):gsub("%s+$", "")
  hs.task.new("/bin/launchctl", function() hs.reload() end,
    { "kickstart", "-k", "gui/" .. uid .. "/org.nixos.yabai" }):start()
end)

hs.alert.show("Hammerspoon loaded")
