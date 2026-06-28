hs.autoLaunch(false)
hs.menuIcon(false)

require("cpu")
require("aerospace_bar")

hs.hotkey.bind({ "cmd", "shift" }, "r", function()
  hs.task.new("/opt/homebrew/bin/aerospace", function() hs.reload() end,
    { "reload-config" }):start()
end)

hs.alert.show("Hammerspoon loaded")
