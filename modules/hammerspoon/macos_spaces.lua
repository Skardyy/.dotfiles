local M = {}

local BAR_HEIGHT         = 26
local NUMBER_W           = 14
local ICON_SIZE          = 16
local ICON_GAP           = 2
local CELL_PAD           = 8
local CELL_INNER_PAD_X   = 4
local CONTAINER_PAD_X    = 3
local FONT_SIZE          = 12
local DIM_ALPHA          = 0.55
local CORNER_RADIUS      = 8
local CELL_CORNER        = 6
local CONTAINER_BG       = { red = 0.07, green = 0.09, blue = 0.13, alpha = 0.28 }
local CONTAINER_STROKE   = { red = 0.60, green = 0.70, blue = 0.85, alpha = 0.35 }
local ACTIVE_CELL_BG     = { red = 0.25, green = 0.35, blue = 0.55, alpha = 0.55 }
local ACTIVE_CELL_STROKE = { red = 0.60, green = 0.75, blue = 0.95, alpha = 0.60 }
local NOTCH_THRESHOLD    = 32
local NOTCH_HALF_WIDTH   = 110

local iconCache = {}

local function iconFor(bundle)
  local cached = iconCache[bundle]
  if cached ~= nil then return cached or nil end
  local icon = hs.image.imageFromAppBundle(bundle)
  iconCache[bundle] = icon or false
  return icon
end

local function menubarHeight(screen)
  return screen:frame().y - screen:fullFrame().y
end

local function hasNotch(screen)
  return menubarHeight(screen) > NOTCH_THRESHOLD
end

local function buildCells(screen)
  local uuid = screen:getUUID()
  local ordered = hs.spaces.allSpaces()[uuid] or {}
  local focused = hs.spaces.focusedSpace()

  local screenSpaceSet = {}
  for _, sid in ipairs(ordered) do screenSpaceSet[sid] = true end

  local entriesPerSpace = {}
  for _, win in ipairs(hs.window.filter.default:getWindows()) do
    local app = win:application()
    local bundle = app and app:bundleID()
    if bundle then
      local sids = hs.spaces.windowSpaces(win:id()) or {}
      local name = app:name() or ""
      for _, sid in ipairs(sids) do
        if screenSpaceSet[sid] then
          local list = entriesPerSpace[sid] or {}
          list[#list + 1] = { bundle = bundle, name = name }
          entriesPerSpace[sid] = list
        end
      end
    end
  end

  local cells = {}
  for i, sid in ipairs(ordered) do
    local entries = entriesPerSpace[sid]
    if entries then
      table.sort(entries, function(a, b)
        if a.name == b.name then return a.bundle < b.bundle end
        return a.name < b.name
      end)
      local bundles = {}
      for j, e in ipairs(entries) do bundles[j] = e.bundle end
      cells[#cells + 1] = { index = i, id = sid, bundles = bundles }
    elseif sid == focused then
      cells[#cells + 1] = { index = i, id = sid, bundles = {} }
    end
  end

  return cells, focused
end

local function cellWidth(cell)
  local n = #cell.bundles
  if n == 0 then return NUMBER_W end
  return NUMBER_W + (n * ICON_SIZE) + ((n - 1) * ICON_GAP) + CELL_INNER_PAD_X
end

local function contentWidth(cells)
  local w = 0
  for i, c in ipairs(cells) do
    w = w + cellWidth(c)
    if i < #cells then w = w + CELL_PAD end
  end
  return w
end

local function buildElements(cells, focused, totalW)
  local elements = {
    {
      type = "rectangle",
      action = "strokeAndFill",
      fillColor = CONTAINER_BG,
      strokeColor = CONTAINER_STROKE,
      strokeWidth = 1,
      roundedRectRadii = { xRadius = CORNER_RADIUS, yRadius = CORNER_RADIUS },
      frame = { x = 0.5, y = 0.5, w = totalW - 1, h = BAR_HEIGHT - 1 },
    },
  }

  local x = CONTAINER_PAD_X
  for i, cell in ipairs(cells) do
    local w = cellWidth(cell)
    local isActive = cell.id == focused
    local alpha = isActive and 1.0 or DIM_ALPHA

    if isActive then
      elements[#elements + 1] = {
        type = "rectangle",
        action = "strokeAndFill",
        fillColor = ACTIVE_CELL_BG,
        strokeColor = ACTIVE_CELL_STROKE,
        strokeWidth = 1,
        roundedRectRadii = { xRadius = CELL_CORNER, yRadius = CELL_CORNER },
        frame = { x = x - 3, y = 1, w = w + 6, h = BAR_HEIGHT - 2 },
      }
    end

    elements[#elements + 1] = {
      type = "text",
      text = tostring(cell.index),
      frame = { x = x, y = (BAR_HEIGHT - FONT_SIZE) / 2 - 2, w = NUMBER_W, h = FONT_SIZE + 6 },
      textColor = { white = 1.0, alpha = alpha },
      textSize = FONT_SIZE,
      textAlignment = "center",
    }

    local iconX = x + NUMBER_W + (CELL_INNER_PAD_X / 2)
    for j, bundle in ipairs(cell.bundles) do
      local icon = iconFor(bundle)
      if icon then
        elements[#elements + 1] = {
          type = "image",
          image = icon,
          frame = { x = iconX, y = (BAR_HEIGHT - ICON_SIZE) / 2, w = ICON_SIZE, h = ICON_SIZE },
          imageAlpha = alpha,
        }
      end
      iconX = iconX + ICON_SIZE
      if j < #cell.bundles then iconX = iconX + ICON_GAP end
    end

    x = x + w
    if i < #cells then x = x + CELL_PAD end
  end

  return elements
end

local function cellsSignature(cells, focused)
  local parts = { focused }
  for _, c in ipairs(cells) do
    parts[#parts + 1] = c.id
    parts[#parts + 1] = c.index
    parts[#parts + 1] = table.concat(c.bundles, ",")
  end
  return table.concat(parts, "|")
end

M.canvases = {}
M.signatures = {}

local function destroyCanvas(uuid)
  local canvas = M.canvases[uuid]
  if canvas then canvas:delete() end
  M.canvases[uuid] = nil
  M.signatures[uuid] = nil
end

local function renderScreen(screen)
  local uuid = screen:getUUID()
  local cells, focused = buildCells(screen)

  if #cells == 0 then
    destroyCanvas(uuid)
    return
  end

  local sig = cellsSignature(cells, focused)
  if M.signatures[uuid] == sig and M.canvases[uuid] then return end
  M.signatures[uuid] = sig

  local totalW = contentWidth(cells) + (CONTAINER_PAD_X * 2)
  local full = screen:fullFrame()
  local y = full.y + math.max(0, (menubarHeight(screen) - BAR_HEIGHT) / 2)
  local x
  if hasNotch(screen) then
    x = full.x + full.w / 2 + NOTCH_HALF_WIDTH
  else
    x = full.x + (full.w - totalW) / 2
  end

  local elements = buildElements(cells, focused, totalW)

  local canvas = M.canvases[uuid]
  if not canvas then
    canvas = hs.canvas.new({ x = x, y = y, w = totalW, h = BAR_HEIGHT })
    canvas:level(hs.canvas.windowLevels.mainMenu + 1)
    canvas:behavior({ hs.canvas.windowBehaviors.canJoinAllSpaces, hs.canvas.windowBehaviors.stationary })
    M.canvases[uuid] = canvas
  else
    canvas:frame({ x = x, y = y, w = totalW, h = BAR_HEIGHT })
  end

  canvas:replaceElements(elements)
  canvas:show()
end

local function render()
  local active = {}
  for _, screen in ipairs(hs.screen.allScreens()) do
    active[screen:getUUID()] = true
    renderScreen(screen)
  end
  for uuid in pairs(M.canvases) do
    if not active[uuid] then destroyCanvas(uuid) end
  end
end

M.spacesWatcher = hs.spaces.watcher.new(render)
M.spacesWatcher:start()

M.screenWatcher = hs.screen.watcher.new(function()
  for uuid in pairs(M.canvases) do destroyCanvas(uuid) end
  render()
end)
M.screenWatcher:start()

M.winFilter = hs.window.filter.new()
M.winFilter:subscribe({
  hs.window.filter.windowCreated,
  hs.window.filter.windowDestroyed,
  hs.window.filter.windowMoved,
  hs.window.filter.windowFocused,
}, render)

render()

return M
