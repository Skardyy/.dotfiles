require("workspace_bar.types")

local cfg = require("workspace_bar.config")
local WM = require("workspace_bar.wm")
local Draw = require("workspace_bar.draw")
local Window = require("workspace_bar.window")
local WindowPeek = require("workspace_bar.window_peek")

local M = {}

M.canvases = {}
M.signatures = {}
M.targets = {}
M.hoverPill = {}

local function destroyCanvas(uuid)
  local canvas = M.canvases[uuid]
  if canvas then canvas:delete() end
  M.canvases[uuid] = nil
  M.signatures[uuid] = nil
  M.targets[uuid] = nil
  M.hoverPill[uuid] = nil
  WindowPeek.clear(uuid)
end

local function attachMouseCallback(canvas, uuid, screen)
  canvas:mouseCallback(function(cv, event, _, mx)
    local targets = M.targets[uuid] or {}
    if event == "mouseExit" then
      WindowPeek.hide(uuid)
      if M.hoverPill[uuid] then
        cv[Draw.HOVER_INDEX] = Draw.hoverElement(nil, nil)
        M.hoverPill[uuid] = nil
      end
      return
    end
    if event == "mouseMove" or event == "mouseEnter" then
      local hovered
      for _, t in ipairs(targets) do
        if mx >= t.from and mx < t.to then
          hovered = t; break
        end
      end
      local pillKey = hovered and (tostring(hovered.pillFrom) .. ":" .. tostring(hovered.pillTo)) or nil
      if pillKey ~= M.hoverPill[uuid] then
        if hovered then
          local cw = cv:frame().w
          cv[Draw.HOVER_INDEX] = Draw.hoverElement(math.max(0, hovered.pillFrom), math.min(cw, hovered.pillTo))
        else
          cv[Draw.HOVER_INDEX] = Draw.hoverElement(nil, nil)
        end
        M.hoverPill[uuid] = pillKey
      end
      if not hovered or not hovered.window or hovered.window.hidden then
        WindowPeek.hide(uuid)
        return
      end
      local f = cv:frame()
      WindowPeek.schedule(uuid, screen, hovered, f.x, f.y)
      return
    end
    if event == "mouseUp" then
      for _, t in ipairs(targets) do
        if mx >= t.from and mx < t.to then
          if t.window and t.window.hidden then
            Window.reveal(t.window)
          elseif t.workspace then
            WM.switchWorkspace(t.workspace)
          end
          WindowPeek.hide(uuid)
          return
        end
      end
    end
  end)
end

---@param hs_screen hs.screen
---@param screen Screen
---@param focusedWindowId (integer|string)?
local function renderScreen(hs_screen, screen, focusedWindowId)
  local uuid = hs_screen:getUUID()

  if #screen.workspaces == 0 then
    destroyCanvas(uuid)
    return
  end

  local sig = Draw.signature(screen.workspaces, screen.focused, focusedWindowId)
  if M.signatures[uuid] == sig and M.canvases[uuid] then return end
  M.signatures[uuid] = sig

  local totalW = Draw.contentWidth(screen.workspaces) + (cfg.CONTAINER_PAD_X * 2)
  local full = hs_screen:fullFrame()
  local y = full.y + math.max(0, (WM.menubarHeight(hs_screen) - cfg.BAR_HEIGHT) / 2)
  local x
  if WM.hasNotch(hs_screen) then
    x = full.x + full.w / 2 + cfg.NOTCH_HALF_WIDTH
  else
    x = full.x + (full.w - totalW) / 2
  end

  local elements, targets = Draw.buildElements(screen.workspaces, screen.focused, focusedWindowId, totalW)
  M.targets[uuid] = targets

  local canvas = M.canvases[uuid]
  if not canvas then
    canvas = hs.canvas.new({ x = x, y = y, w = totalW, h = cfg.BAR_HEIGHT })
    canvas:level(hs.canvas.windowLevels.mainMenu + 1)
    canvas:behavior({ hs.canvas.windowBehaviors.canJoinAllSpaces, hs.canvas.windowBehaviors.stationary })
    canvas:canvasMouseEvents(false, true, true, true)
    attachMouseCallback(canvas, uuid, hs_screen)
    M.canvases[uuid] = canvas
  else
    canvas:frame({ x = x, y = y, w = totalW, h = cfg.BAR_HEIGHT })
  end

  canvas:replaceElements(elements)
  canvas:show()
end

local render

local pendingRender = nil
local function scheduleRender()
  if pendingRender then return end
  pendingRender = hs.timer.doAfter(cfg.RENDER_DEBOUNCE, function()
    pendingRender = nil
    render()
  end)
end

render = function()
  WM.fetch(function(screens, focusedWindowId)
    local active = {}
    for _, hs_screen in ipairs(hs.screen.allScreens()) do
      local uuid = hs_screen:getUUID()
      active[uuid] = true
      local screen = screens[uuid]
      if screen then
        renderScreen(hs_screen, screen, focusedWindowId)
      else
        destroyCanvas(uuid)
      end
    end
    for uuid in pairs(M.canvases) do
      if not active[uuid] then destroyCanvas(uuid) end
    end
  end)
end

M.render = render

---@class WorkspaceBarOpts
---@field source string?

---@param opts WorkspaceBarOpts?
local function findIconTargetAt(x, y)
  for uuid, canvas in pairs(M.canvases) do
    local f = canvas:frame()
    if x >= f.x and x < f.x + f.w and y >= f.y and y < f.y + f.h then
      local mx = x - f.x
      for _, t in ipairs(M.targets[uuid] or {}) do
        if t.kind == "icon" and mx >= t.from and mx < t.to then
          return t
        end
      end
      return nil
    end
  end
  return nil
end

function M.setup(opts)
  opts = opts or {}
  WM.load(opts.source or "aerospace")

  M.middleClickTap = hs.eventtap.new({ hs.eventtap.event.types.otherMouseUp }, function(e)
    local button = e:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber)
    if button ~= 2 then return false end
    local p = hs.mouse.absolutePosition()
    local target = findIconTargetAt(p.x, p.y)
    if target and target.window then
      Window.close(target.window)
      return true
    end
    return false
  end)
  M.middleClickTap:start()

  M.screenWatcher = hs.screen.watcher.new(function()
    for uuid in pairs(M.canvases) do destroyCanvas(uuid) end
    render()
  end)
  M.screenWatcher:start()

  M.winFilter = hs.window.filter.new(true)
  M.winFilter:subscribe({
    hs.window.filter.windowCreated,
    hs.window.filter.windowDestroyed,
    hs.window.filter.windowMoved,
    hs.window.filter.windowFocused,
    hs.window.filter.windowUnfocused,
    hs.window.filter.windowMinimized,
    hs.window.filter.windowUnminimized,
    hs.window.filter.windowHidden,
    hs.window.filter.windowUnhidden,
  }, scheduleRender)

  M.eventTask = WM.subscribe(scheduleRender)

  hs.urlevent.bind("refreshbar", scheduleRender)

  render()
end

return M
