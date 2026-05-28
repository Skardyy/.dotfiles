-- Menu bar indicator: shows non-empty Spaces with a primary app icon per space.
-- Current space is bright; others are dimmed. Always shows current space even if empty.

local M = {}

M.menu = hs.menubar.new()
local menu = M.menu

-- Visual config
local BAR_HEIGHT  = 22
local NUMBER_W    = 12
local ICON_SIZE   = 18
local CELL_PAD    = 6  -- space between cells (after icon, before next number)
local FONT_SIZE   = 13
local DIM_ALPHA   = 0.55

local function spacesWithWindows()
  local screen = hs.screen.primaryScreen():getUUID()
  local ordered = hs.spaces.allSpaces()[screen] or {}

  local hasWindow = {}
  local firstAppPerSpace = {}
  for _, win in ipairs(hs.window.filter.default:getWindows()) do
    local sids = hs.spaces.windowSpaces(win:id()) or {}
    for _, sid in ipairs(sids) do
      hasWindow[sid] = true
      if not firstAppPerSpace[sid] then
        local app = win:application()
        if app and app:bundleID() then
          firstAppPerSpace[sid] = app:bundleID()
        end
      end
    end
  end

  local cells = {}
  for i, sid in ipairs(ordered) do
    if hasWindow[sid] then
      table.insert(cells, { index = i, id = sid, bundle = firstAppPerSpace[sid] })
    end
  end
  return cells, ordered
end

local function render()
  local focused = hs.spaces.focusedSpace()
  local cells, ordered = spacesWithWindows()

  -- Include current space if not already in cells (no bundle = no icon reserved)
  local seen = {}
  for _, s in ipairs(cells) do seen[s.id] = true end
  if not seen[focused] then
    for i, sid in ipairs(ordered) do
      if sid == focused then
        table.insert(cells, { index = i, id = sid, bundle = nil })
        table.sort(cells, function(a, b) return a.index < b.index end)
        break
      end
    end
  end

  if #cells == 0 then
    menu:setIcon(nil)
    menu:setTitle("·")
    return
  end

  -- Per-cell width: has icon vs no icon
  local widthFor = function(c) return c.bundle and (NUMBER_W + ICON_SIZE) or NUMBER_W end
  local totalWidth = 0
  for i, c in ipairs(cells) do
    totalWidth = totalWidth + widthFor(c)
    if i < #cells then totalWidth = totalWidth + CELL_PAD end
  end

  local canvas = hs.canvas.new({ x = 0, y = 0, w = totalWidth, h = BAR_HEIGHT })

  local x = 0
  for i, s in ipairs(cells) do
    local active = (s.id == focused)
    local alpha = active and 1.0 or DIM_ALPHA

    -- Number
    canvas:appendElements({
      type = "text",
      text = tostring(s.index),
      frame = { x = x, y = 2, w = NUMBER_W, h = BAR_HEIGHT - 2 },
      textColor = { white = 1.0, alpha = alpha },
      textSize = FONT_SIZE,
      textAlignment = "center",
    })

    if s.bundle then
      local icon = hs.image.imageFromAppBundle(s.bundle)
      if icon then
        canvas:appendElements({
          type = "image",
          image = icon,
          frame = { x = x + NUMBER_W, y = (BAR_HEIGHT - ICON_SIZE) / 2, w = ICON_SIZE, h = ICON_SIZE },
          imageAlpha = alpha,
        })
      end
    end

    x = x + widthFor(s)
    if i < #cells then x = x + CELL_PAD end
  end

  local img = canvas:imageFromCanvas()
  menu:setTitle("")
  menu:setIcon(img, false)
end

M.spacesWatcher = hs.spaces.watcher.new(render)
M.spacesWatcher:start()

M.winFilter = hs.window.filter.new()
M.winFilter:subscribe({
  hs.window.filter.windowCreated,
  hs.window.filter.windowDestroyed,
  hs.window.filter.windowMoved,
  hs.window.filter.windowFocused,
}, render)

render()

return M
