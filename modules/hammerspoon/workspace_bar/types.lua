---@meta

-- one on-screen window (may belong to a workspace, or sit in the hidden bucket).
---@class Window
---@field id (integer|string)?
---@field bundle string
---@field name string
---@field hidden boolean

-- one workspace on a screen. holds the windows placed in it.
---@class Workspace
---@field id string|integer
---@field visible boolean
---@field windows Window[]

-- one physical screen. holds the workspaces on it and which is focused.
---@class Screen
---@field id integer|string
---@field name string
---@field workspaces Workspace[]
---@field focused (string|integer)?

-- what the source returns in one poll.
---@class WMSnapshot
---@field screens Screen[]
---@field focused_window_id (integer|string)?

-- horizontal x-range on the bar; a mouse hit inside maps to focusing a
-- window (kind = "icon") or switching a workspace (kind = "cell").
---@class MouseTarget
---@field kind "icon"|"cell"
---@field from number
---@field to number
---@field window Window?
---@field workspace (string|integer)?

---@class WindowPeekState
---@field canvas hs.canvas?
---@field timer hs.timer?
---@field pendingKey string?
---@field currentKey string?
