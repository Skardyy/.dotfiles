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

local function show(uuid, screen, target, barX, barY)
  local w = target.window
  if not w or not w.id then return end
  local snap, title = Window.snapshot(w)
  if not snap then return end

  local iconAbsCenterX = barX + (target.from + target.to) / 2
  local peekY = barY + cfg.BAR_HEIGHT + cfg.PEEK_MARGIN
  local peekX = iconAbsCenterX - cfg.PEEK_W / 2
  local sf = screen:fullFrame()
  peekX = math.max(sf.x + 4, math.min(peekX, sf.x + sf.w - cfg.PEEK_W - 4))

  local p = WindowPeek.state[uuid] or {}
  WindowPeek.state[uuid] = p
  if p.canvas then p.canvas:delete() end
  local c = hs.canvas.new({ x = peekX, y = peekY, w = cfg.PEEK_W, h = cfg.PEEK_H })
  c:level(hs.canvas.windowLevels.mainMenu)
  c:behavior({ hs.canvas.windowBehaviors.canJoinAllSpaces, hs.canvas.windowBehaviors.stationary })
  c:canvasMouseEvents(false, false, false, false)

  local imgW = cfg.PEEK_W - cfg.PEEK_INNER_PAD * 2
  local imgH = cfg.PEEK_H - cfg.PEEK_INNER_PAD * 2 - 14
  c:replaceElements({
    {
      type = "rectangle",
      action = "strokeAndFill",
      fillColor = cfg.PEEK_BG,
      strokeColor = cfg.PEEK_STROKE,
      strokeWidth = 1,
      roundedRectRadii = { xRadius = cfg.PEEK_CORNER, yRadius = cfg.PEEK_CORNER },
      frame = { x = 0.5, y = 0.5, w = cfg.PEEK_W - 1, h = cfg.PEEK_H - 1 },
    },
    {
      type = "image",
      image = snap,
      frame = { x = cfg.PEEK_INNER_PAD, y = cfg.PEEK_INNER_PAD, w = imgW, h = imgH },
      imageScaling = "scaleProportionally",
    },
    {
      type = "text",
      text = title or w.name or "",
      frame = { x = cfg.PEEK_INNER_PAD, y = cfg.PEEK_INNER_PAD + imgH, w = imgW, h = 14 },
      textColor = { white = 1.0, alpha = 0.85 },
      textSize = 11,
      textAlignment = "center",
    },
  })
  c:show()
  p.canvas = c
  p.currentKey = windowKey(w)
end

---@param uuid string
---@param screen hs.screen
---@param target MouseTarget
---@param barX number
---@param barY number
function WindowPeek.schedule(uuid, screen, target, barX, barY)
  local key = windowKey(target.window)
  local p = WindowPeek.state[uuid] or {}
  WindowPeek.state[uuid] = p
  if p.pendingKey == key or p.currentKey == key then return end
  if p.timer then
    p.timer:stop(); p.timer = nil
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
