-- Menu bar CPU percentage indicator.

local M = {}

M.menu = hs.menubar.new()
local menu = M.menu

menu:setClickCallback(function()
  hs.application.launchOrFocus("Activity Monitor")
end)

local FONT = { name = ".AppleSystemUIFont", size = 13 }

local function update()
  hs.host.cpuUsage(0.5, function(result)
    if not (result and result.overall) then return end
    local pct = math.floor(result.overall.active + 0.5)
    menu:setTitle(hs.styledtext.new(string.format("▣ %d%%", pct), {
      color = { white = 1.0 },
      font = FONT,
    }))
  end)
end

M.timer = hs.timer.doEvery(3, update)
update()

return M
