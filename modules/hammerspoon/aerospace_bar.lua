local M                  = {}

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

local AEROSPACE          = "/opt/homebrew/bin/aerospace"

local LABEL_OVERRIDES    = { ["10"] = "~" }

local function labelFor(ws)
  return LABEL_OVERRIDES[tostring(ws)] or tostring(ws)
end

local iconCache = {}

local function iconFor(bundle)
  if not bundle then return nil end
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

-- Fire an async aerospace command. onResult receives the parsed JSON (or nil).
local function aerospace(args, onResult)
  hs.task.new(AEROSPACE, function(_, stdout)
    if not stdout or stdout == "" then
      if onResult then onResult(nil) end
      return
    end
    local ok, decoded = pcall(hs.json.decode, stdout)
    if onResult then onResult(ok and decoded or nil) end
  end, args):start()
end

-- Run several aerospace queries concurrently and call onDone with the merged results.
local function aerospaceBatch(specs, onDone)
  local pending = 0
  for _ in pairs(specs) do pending = pending + 1 end
  local results = {}
  local function finish(key, value)
    results[key] = value
    pending = pending - 1
    if pending == 0 then onDone(results) end
  end
  for key, args in pairs(specs) do
    aerospace(args, function(d) finish(key, d) end)
  end
end

-- === Data model ===

-- Returns { [screenUUID] = { cells = {...}, focused = "<workspace name>" }, ... }
local function buildScreens(monitors, workspaces, windows)
  local screensByName, screensByIndex = {}, {}
  for i, screen in ipairs(hs.screen.allScreens()) do
    screensByIndex[i] = screen
    screensByName[screen:name() or ""] = screen
  end

  local screenByMonitorId = {}
  for _, m in ipairs(monitors or {}) do
    local mid = m["monitor-id"]
    local mname = m["monitor-name"]
    local screen = screensByName[mname] or screensByIndex[mid]
    if screen then screenByMonitorId[mid] = screen end
  end

  local visibleByMonitor = {}
  for _, w in ipairs(workspaces or {}) do
    if w["workspace-is-visible"] then
      visibleByMonitor[w["monitor-id"]] = w["workspace"]
    end
  end

  local windowsByWorkspace = {}
  local monitorByWorkspace = {}
  for _, win in ipairs(windows or {}) do
    local ws = win["workspace"]
    local mid = win["monitor-id"]
    local bundle = win["app-bundle-id"]
    local name = win["app-name"] or ""
    local wid = win["window-id"]
    if ws and bundle then
      windowsByWorkspace[ws] = windowsByWorkspace[ws] or {}
      table.insert(windowsByWorkspace[ws], { id = wid, bundle = bundle, name = name })
    end
    if ws and mid and not monitorByWorkspace[ws] then
      monitorByWorkspace[ws] = mid
    end
  end

  for mid, ws in pairs(visibleByMonitor) do
    if not monitorByWorkspace[ws] then monitorByWorkspace[ws] = mid end
  end

  local hsWins = {}
  for _, w in ipairs(hs.window.allWindows()) do
    hsWins[w:id()] = w
  end

  local function entryX(entry)
    local hw = hsWins[entry.id]
    if hw then
      local f = hw:frame()
      if f then return f.x end
    end
    return math.huge
  end

  local cellsByMonitor = {}
  for ws, mid in pairs(monitorByWorkspace) do
    local entries = windowsByWorkspace[ws] or {}
    table.sort(entries, function(a, b)
      local ax, bx = entryX(a), entryX(b)
      if ax ~= bx then return ax < bx end
      return tostring(a.id) < tostring(b.id)
    end)

    local isVisible = visibleByMonitor[mid] == ws
    if #entries > 0 or isVisible then
      cellsByMonitor[mid] = cellsByMonitor[mid] or {}
      table.insert(cellsByMonitor[mid], { id = ws, entries = entries })
    end
  end

  local function cellSortKey(cell)
    local sid = tostring(cell.id)
    if LABEL_OVERRIDES[sid] then return "z" .. sid end
    local n = tonumber(sid)
    if n then return string.format("a%020d", n) end
    return "y" .. sid
  end

  local result = {}
  for mid, screen in pairs(screenByMonitorId) do
    local cells = cellsByMonitor[mid] or {}
    table.sort(cells, function(a, b) return cellSortKey(a) < cellSortKey(b) end)
    result[screen:getUUID()] = {
      cells = cells,
      focused = visibleByMonitor[mid],
    }
  end
  return result
end

-- === Rendering ===

local function cellWidth(cell)
  local n = #cell.entries
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

local function buildElements(cells, focused, focusedWindowId, totalW)
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
  local hitZones = {}

  local x = CONTAINER_PAD_X
  for i, cell in ipairs(cells) do
    local w = cellWidth(cell)
    local isActive = cell.id == focused
    local cellAlpha = isActive and 1.0 or DIM_ALPHA

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
      text = labelFor(cell.id),
      frame = { x = x, y = (BAR_HEIGHT - FONT_SIZE) / 2 - 2, w = NUMBER_W, h = FONT_SIZE + 6 },
      textColor = { white = 1.0, alpha = cellAlpha },
      textSize = FONT_SIZE,
      textAlignment = "center",
    }

    local iconX = x + NUMBER_W + (CELL_INNER_PAD_X / 2)
    for j, entry in ipairs(cell.entries) do
      local icon = iconFor(entry.bundle)
      if icon then
        local iconAlpha = cellAlpha
        if isActive and entry.id ~= focusedWindowId then
          iconAlpha = DIM_ALPHA
        end
        elements[#elements + 1] = {
          type = "image",
          image = icon,
          frame = { x = iconX, y = (BAR_HEIGHT - ICON_SIZE) / 2, w = ICON_SIZE, h = ICON_SIZE },
          imageAlpha = iconAlpha,
        }
      end
      iconX = iconX + ICON_SIZE
      if j < #cell.entries then iconX = iconX + ICON_GAP end
    end

    local zoneStart = (i == 1) and 0 or (x - CELL_PAD / 2)
    local zoneEnd = (i == #cells) and totalW or (x + w + CELL_PAD / 2)
    hitZones[#hitZones + 1] = { from = zoneStart, to = zoneEnd, workspace = cell.id }

    x = x + w
    if i < #cells then x = x + CELL_PAD end
  end

  return elements, hitZones
end

local function cellsSignature(cells, focused, focusedWindowId)
  local parts = { tostring(focused), tostring(focusedWindowId) }
  for _, c in ipairs(cells) do
    parts[#parts + 1] = tostring(c.id)
    for _, e in ipairs(c.entries) do
      parts[#parts + 1] = (e.bundle or "") .. ":" .. tostring(e.id)
    end
  end
  return table.concat(parts, "|")
end

M.canvases = {}
M.signatures = {}
M.hitZones = {}

local function destroyCanvas(uuid)
  local canvas = M.canvases[uuid]
  if canvas then canvas:delete() end
  M.canvases[uuid] = nil
  M.signatures[uuid] = nil
  M.hitZones[uuid] = nil
end

local function switchWorkspace(name)
  hs.task.new(AEROSPACE, nil, { "workspace", tostring(name) }):start()
end

local function renderScreen(screen, cells, focused, focusedWindowId)
  local uuid = screen:getUUID()

  if #cells == 0 then
    destroyCanvas(uuid)
    return
  end

  local sig = cellsSignature(cells, focused, focusedWindowId)
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

  local elements, hitZones = buildElements(cells, focused, focusedWindowId, totalW)
  M.hitZones[uuid] = hitZones

  local canvas = M.canvases[uuid]
  if not canvas then
    canvas = hs.canvas.new({ x = x, y = y, w = totalW, h = BAR_HEIGHT })
    canvas:level(hs.canvas.windowLevels.mainMenu + 1)
    canvas:behavior({ hs.canvas.windowBehaviors.canJoinAllSpaces, hs.canvas.windowBehaviors.stationary })
    canvas:canvasMouseEvents(false, true, false, false)
    canvas:mouseCallback(function(_, event, _, clickX)
      if event ~= "mouseUp" then return end
      for _, z in ipairs(M.hitZones[uuid] or {}) do
        if clickX >= z.from and clickX < z.to then
          switchWorkspace(z.workspace)
          return
        end
      end
    end)
    M.canvases[uuid] = canvas
  else
    canvas:frame({ x = x, y = y, w = totalW, h = BAR_HEIGHT })
  end

  canvas:replaceElements(elements)
  canvas:show()
end

local function render()
  aerospaceBatch({
    monitors = { "list-monitors", "--json",
      "--format", "%{monitor-id}%{monitor-name}" },
    workspaces = { "list-workspaces", "--all", "--json",
      "--format", "%{workspace}%{monitor-id}%{workspace-is-visible}" },
    windows = { "list-windows", "--all", "--json",
      "--format", "%{window-id}%{app-name}%{app-bundle-id}%{workspace}%{monitor-id}" },
    focusedWindow = { "list-windows", "--focused", "--json",
      "--format", "%{window-id}" },
  }, function(r)
    local screens = buildScreens(r.monitors, r.workspaces, r.windows)
    local focusedWindowId = r.focusedWindow and r.focusedWindow[1] and r.focusedWindow[1]["window-id"]

    local active = {}
    for _, screen in ipairs(hs.screen.allScreens()) do
      local uuid = screen:getUUID()
      active[uuid] = true
      local data = screens[uuid]
      if data then
        renderScreen(screen, data.cells, data.focused, focusedWindowId)
      else
        destroyCanvas(uuid)
      end
    end
    for uuid in pairs(M.canvases) do
      if not active[uuid] then destroyCanvas(uuid) end
    end
  end)
end

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
  hs.window.filter.windowUnfocused,
}, render)

hs.urlevent.bind("refreshbar", render)

render()

return M
