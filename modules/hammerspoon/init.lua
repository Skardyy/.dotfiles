hs.autoLaunch(false)
hs.menuIcon(false)

package.path = package.path
    .. ";" .. hs.configdir .. "/?.lua"
    .. ";" .. hs.configdir .. "/?/init.lua"

require("cpu")

local WM = "aerospace"

require("workspace_bar").setup({ source = WM })

hs.hotkey.bind({ "cmd", "shift" }, "r", function()
  local reload_cmd = WM == "rift"
      and { "/opt/homebrew/bin/rift-cli", "execute", "config", "reload" }
      or { "/opt/homebrew/bin/aerospace", "reload-config" }
  hs.task.new(reload_cmd[1], function() hs.reload() end,
    { table.unpack(reload_cmd, 2) }):start()
end)

hs.alert.show("Hammerspoon loaded (" .. WM .. ")")
