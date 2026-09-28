local Window = {}

---@param opts { id: (integer|string)?, bundle: string, name: string?, hidden: boolean? }
---@return Window
function Window.new(opts)
  return {
    id = opts.id,
    bundle = opts.bundle,
    name = opts.name or "",
    hidden = opts.hidden or false,
  }
end

local iconCache = {}

---@param w Window
---@return hs.image?
function Window.icon(w)
  local bundle = w and w.bundle
  if not bundle then return nil end
  local cached = iconCache[bundle]
  if cached ~= nil then return cached or nil end
  local icon = hs.image.imageFromAppBundle(bundle)
  iconCache[bundle] = icon or false
  return icon
end

---@param w Window
---@return hs.window?
function Window.resolve(w)
  if not w or not w.id then return nil end
  local hw = hs.window.get(w.id)
  if hw then return hw end
  if not w.bundle then return nil end
  local app = hs.application.get(w.bundle)
  if not app then return nil end
  for _, cand in ipairs(app:allWindows()) do
    if cand:id() == w.id then return cand end
  end
  return nil
end

---@param w Window
function Window.focus(w)
  local hw = Window.resolve(w)
  if hw then hw:focus() end
end

---@param w Window
function Window.reveal(w)
  if not w then return end
  if w.bundle then
    local app = hs.application.get(w.bundle)
    if app and app:isHidden() then app:unhide() end
  end
  local hw = Window.resolve(w)
  if not hw then return end
  if hw:isMinimized() then
    local ax = hs.axuielement.windowElement(hw)
    if ax then ax:setAttributeValue("AXMinimized", false) end
  end
  hw:focus()
end

---@param w Window
function Window.close(w)
  local hw = Window.resolve(w)
  if hw then hw:close() end
end

---@param w Window
---@return hs.image?, string?
function Window.snapshot(w)
  local hw = Window.resolve(w)
  if not hw then return nil, nil end
  return hw:snapshot(), hw:title()
end

return Window
