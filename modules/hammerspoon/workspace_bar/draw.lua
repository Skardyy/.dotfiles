local cfg = require("workspace_bar.config")
local Window = require("workspace_bar.window")
local Workspace = require("workspace_bar.workspace")

local Draw = {}

---@param ws Workspace
---@return number
function Draw.workspaceWidth(ws)
  local n = #ws.windows
  local isHidden = Workspace.isHidden(ws)
  local labelW = isHidden and 0 or cfg.NUMBER_W
  local sepW = isHidden and (cfg.HIDDEN_SEP_GAP * 2) or 0
  if n == 0 then return labelW + sepW end
  return labelW + sepW + (n * cfg.ICON_SIZE) + ((n - 1) * cfg.ICON_GAP) + cfg.CELL_INNER_PAD_X
end

---@param workspaces Workspace[]
---@return number
function Draw.contentWidth(workspaces)
  local w = 0
  for i, ws in ipairs(workspaces) do
    w = w + Draw.workspaceWidth(ws)
    if i < #workspaces then w = w + cfg.CELL_PAD end
  end
  return w
end

local function containerElement(totalW)
  return {
    type = "rectangle",
    action = "strokeAndFill",
    fillColor = cfg.CONTAINER_BG,
    strokeColor = cfg.CONTAINER_STROKE,
    strokeWidth = 1,
    roundedRectRadii = { xRadius = cfg.CORNER_RADIUS, yRadius = cfg.CORNER_RADIUS },
    frame = { x = 0.5, y = 0.5, w = totalW - 1, h = cfg.BAR_HEIGHT - 1 },
  }
end

local function activeCellBacking(x, w)
  return {
    type = "rectangle",
    action = "strokeAndFill",
    fillColor = cfg.ACTIVE_CELL_BG,
    strokeColor = cfg.ACTIVE_CELL_STROKE,
    strokeWidth = 1,
    roundedRectRadii = { xRadius = cfg.CELL_CORNER, yRadius = cfg.CELL_CORNER },
    frame = {
      x = x - cfg.ACTIVE_INSET_X,
      y = cfg.ACTIVE_INSET_Y,
      w = w + cfg.ACTIVE_INSET_X * 2,
      h = cfg.BAR_HEIGHT - cfg.ACTIVE_INSET_H,
    },
  }
end

local function hiddenDivider(x)
  return {
    type = "rectangle",
    action = "fill",
    fillColor = cfg.HIDDEN_SEP_COLOR,
    frame = { x = x - cfg.CELL_PAD / 2, y = 4, w = cfg.HIDDEN_SEP_WIDTH, h = cfg.BAR_HEIGHT - 8 },
  }
end

local function labelElement(x, ws, alpha)
  return {
    type = "text",
    text = Workspace.labelFor(ws.id),
    frame = { x = x, y = (cfg.BAR_HEIGHT - cfg.FONT_SIZE) / 2 - 2, w = cfg.NUMBER_W, h = cfg.FONT_SIZE + 6 },
    textColor = { white = 1.0, alpha = alpha },
    textSize = cfg.FONT_SIZE,
    textAlignment = "center",
  }
end

local function iconElement(iconX, iconY, icon, alpha)
  return {
    type = "image",
    image = icon,
    frame = { x = iconX, y = iconY, w = cfg.ICON_SIZE, h = cfg.ICON_SIZE },
    imageAlpha = alpha,
  }
end

local function hiddenBadgeElements(iconX, iconY)
  local cx = iconX + cfg.ICON_SIZE - cfg.HIDDEN_BADGE_GLOW_R
  local cy = iconY + cfg.ICON_SIZE - cfg.HIDDEN_BADGE_GLOW_R
  return {
    {
      type = "circle",
      action = "fill",
      fillColor = cfg.HIDDEN_BADGE_GLOW,
      center = { x = cx, y = cy },
      radius = cfg.HIDDEN_BADGE_GLOW_R,
    },
    {
      type = "text",
      text = cfg.HIDDEN_BADGE_TEXT,
      textColor = cfg.HIDDEN_BADGE_COLOR,
      frame = {
        x = cx - cfg.HIDDEN_BADGE_SIZE / 2,
        y = cy - cfg.HIDDEN_BADGE_SIZE / 2 - 1,
        w = cfg.HIDDEN_BADGE_SIZE,
        h = cfg.HIDDEN_BADGE_SIZE + 2,
      },
      textSize = cfg.HIDDEN_BADGE_SIZE,
      textAlignment = "center",
    },
  }
end

---@param w Window
---@param isActive boolean
---@param cellAlpha number
---@param focusedWindowId (integer|string)?
local function windowAlpha(w, isActive, cellAlpha, focusedWindowId)
  if w.hidden then return cfg.HIDDEN_ICON_ALPHA end
  if isActive and w.id ~= focusedWindowId then return cfg.DIM_ALPHA end
  return cellAlpha
end

---@param workspaces Workspace[]
---@param focused (string|integer)?
---@param focusedWindowId (integer|string)?
---@param totalW number
---@return table elements, MouseTarget[] mouseTargets
function Draw.buildElements(workspaces, focused, focusedWindowId, totalW)
  local elements = { containerElement(totalW) }
  local mouseTargets = {}

  local x = cfg.CONTAINER_PAD_X
  for i, ws in ipairs(workspaces) do
    local w = Draw.workspaceWidth(ws)
    local isActive = ws.id == focused
    local isHiddenWs = Workspace.isHidden(ws)
    local cellAlpha = isActive and 1.0 or cfg.DIM_ALPHA

    if isActive then
      elements[#elements + 1] = activeCellBacking(x, w)
    end

    if isHiddenWs then
      x = x + cfg.HIDDEN_SEP_GAP
      elements[#elements + 1] = hiddenDivider(x)
      x = x + cfg.HIDDEN_SEP_GAP
    else
      elements[#elements + 1] = labelElement(x, ws, cellAlpha)
    end

    local labelOffset = isHiddenWs and 0 or cfg.NUMBER_W
    local iconX = x + labelOffset + (cfg.CELL_INNER_PAD_X / 2)
    local iconY = (cfg.BAR_HEIGHT - cfg.ICON_SIZE) / 2
    for j, window in ipairs(ws.windows) do
      local icon = Window.icon(window)
      if icon then
        local alpha = windowAlpha(window, isActive, cellAlpha, focusedWindowId)
        elements[#elements + 1] = iconElement(iconX, iconY, icon, alpha)
        if window.hidden then
          for _, el in ipairs(hiddenBadgeElements(iconX, iconY)) do
            elements[#elements + 1] = el
          end
        end
      end
      mouseTargets[#mouseTargets + 1] = {
        kind = "icon",
        from = iconX - cfg.ICON_GAP / 2,
        to = iconX + cfg.ICON_SIZE + cfg.ICON_GAP / 2,
        window = window,
      }
      iconX = iconX + cfg.ICON_SIZE
      if j < #ws.windows then iconX = iconX + cfg.ICON_GAP end
    end

    local zoneStart = (i == 1) and 0 or (x - cfg.CELL_PAD / 2)
    local zoneEnd = (i == #workspaces) and totalW or (x + w + cfg.CELL_PAD / 2)
    mouseTargets[#mouseTargets + 1] = { kind = "cell", from = zoneStart, to = zoneEnd, workspace = ws.id }

    x = x + w
    if i < #workspaces then x = x + cfg.CELL_PAD end
  end

  return elements, mouseTargets
end

---@param workspaces Workspace[]
---@param focused (string|integer)?
---@param focusedWindowId (integer|string)?
---@return string
function Draw.signature(workspaces, focused, focusedWindowId)
  local parts = { tostring(focused), tostring(focusedWindowId) }
  for _, ws in ipairs(workspaces) do
    parts[#parts + 1] = tostring(ws.id)
    for _, w in ipairs(ws.windows) do
      parts[#parts + 1] = (w.bundle or "") .. ":" .. tostring(w.id) .. ":" .. (w.hidden and "h" or "v")
    end
  end
  return table.concat(parts, "|")
end

return Draw
