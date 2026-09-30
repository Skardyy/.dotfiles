local cfg = require("workspace_bar.config")
local Window = require("workspace_bar.window")

local WindowPeek = {}

---@type table<string, WindowPeekState>
WindowPeek.state = {}

local function windowKey(w)
  return tostring(w.id or "") .. "|" .. tostring(w.bundle or "")
end

---@param uuid string
function WindowPeek.hide(uuid)
  local p = WindowPeek.state[uuid]
  if not p then return end
  if p.timer then
    p.timer:stop(); p.timer = nil
  end
  if p.canvas then
    p.canvas:delete(); p.canvas = nil
  end
  p.currentKey = nil
  p.pendingKey = nil
end

---@param uuid string
function WindowPeek.clear(uuid)
  WindowPeek.hide(uuid)
  WindowPeek.state[uuid] = nil
end

local function snapshotAll(wins)
  local out = {}
  for _, w in ipairs(wins) do
    if w and w.id and not w.hidden then
      local snap, title = Window.snapshot(w)
      if snap then
        out[#out + 1] = { image = snap, title = title or w.name or "" }
      end
    end
  end
  return out
end

local function show(uuid, screen, target, barX, barY)
  local wins = target.windows
  if not wins or #wins == 0 then
    if target.window then wins = { target.window } else return end
  end

  local shots = snapshotAll(wins)
  if #shots == 0 then return end

  local sf = screen:fullFrame()
  local n = #shots
  local imgH = sf.h * cfg.PEEK_TILE_H_RATIO
  local tiles = {}
  local totalImgW = 0
  for _, shot in ipairs(shots) do
    local sz = shot.image:size()
    local aspect = (sz.w > 0 and sz.h > 0) and (sz.w / sz.h) or 1
    local w = imgH * aspect
    tiles[#tiles + 1] = { image = shot.image, title = shot.title, w = w }
    totalImgW = totalImgW + w
  end
  local maxW = sf.w * cfg.PEEK_MAX_W_RATIO
  local avail = maxW - (n - 1) * cfg.PEEK_TILE_GAP - cfg.PEEK_INNER_PAD * 2
  if totalImgW > avail then
    local scale = avail / totalImgW
    imgH = imgH * scale
    totalImgW = 0
    for _, t in ipairs(tiles) do
      t.w = t.w * scale
      totalImgW = totalImgW + t.w
    end
  end
  local peekW = totalImgW + (n - 1) * cfg.PEEK_TILE_GAP + cfg.PEEK_INNER_PAD * 2
  local peekH = imgH + cfg.PEEK_INNER_PAD * 2 + cfg.PEEK_TITLE_H

  local pillCenterAbs = barX + (target.pillFrom + target.pillTo) / 2
  local peekY = barY + cfg.BAR_HEIGHT + cfg.PEEK_MARGIN
  local peekX = pillCenterAbs - peekW / 2
  peekX = math.max(sf.x + 4, math.min(peekX, sf.x + sf.w - peekW - 4))

  local p = WindowPeek.state[uuid] or {}
  WindowPeek.state[uuid] = p
  if p.canvas then p.canvas:delete() end
  local c = hs.canvas.new({ x = peekX, y = peekY, w = peekW, h = peekH })
  c:level(hs.canvas.windowLevels.mainMenu)
  c:behavior({ hs.canvas.windowBehaviors.canJoinAllSpaces, hs.canvas.windowBehaviors.stationary })
  c:canvasMouseEvents(false, false, false, false)

  local elements = {
    {
      type = "rectangle",
      action = "strokeAndFill",
      fillColor = cfg.PEEK_BG,
      strokeColor = cfg.PEEK_STROKE,
      strokeWidth = 1,
      roundedRectRadii = { xRadius = cfg.PEEK_CORNER, yRadius = cfg.PEEK_CORNER },
      frame = { x = 0.5, y = 0.5, w = peekW - 1, h = peekH - 1 },
    },
  }
  local x = cfg.PEEK_INNER_PAD
  for _, t in ipairs(tiles) do
    elements[#elements + 1] = {
      type = "image",
      image = t.image,
      frame = { x = x, y = cfg.PEEK_INNER_PAD, w = t.w, h = imgH },
      imageScaling = "scaleProportionally",
    }
    elements[#elements + 1] = {
      type = "text",
      text = t.title,
      frame = { x = x, y = cfg.PEEK_INNER_PAD + imgH, w = t.w, h = cfg.PEEK_TITLE_H },
      textColor = { white = 1.0, alpha = 0.85 },
      textSize = 11,
      textAlignment = "center",
    }
    x = x + t.w + cfg.PEEK_TILE_GAP
  end
  c:replaceElements(elements)
  c:show()
  p.canvas = c
  p.currentKey = tostring(target.workspace or "")
end

---@param uuid string
---@param screen hs.screen
---@param target MouseTarget
---@param barX number
---@param barY number
function WindowPeek.schedule(uuid, screen, target, barX, barY)
  local key = tostring(target.workspace or windowKey(target.window or {}))
  local p = WindowPeek.state[uuid] or {}
  WindowPeek.state[uuid] = p
  if p.pendingKey == key or p.currentKey == key then return end
  if p.timer then
    p.timer:stop(); p.timer = nil
  end
  -- once a peek is already visible for this bar, switching to a new target
  -- swaps instantly. delay only applies when peek is starting from cold.
  if p.currentKey then
    p.pendingKey = nil
    show(uuid, screen, target, barX, barY)
    return
  end
  p.pendingKey = key
  p.timer = hs.timer.doAfter(cfg.PEEK_DELAY, function()
    local pp = WindowPeek.state[uuid]
    if not pp or pp.pendingKey ~= key then return end
    pp.pendingKey = nil
    pp.timer = nil
    show(uuid, screen, target, barX, barY)
  end)
end

return WindowPeek
