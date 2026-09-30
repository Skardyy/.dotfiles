local M               = {}

-- Bar geometry.
M.BAR_HEIGHT          = 26
M.CONTAINER_PAD_X     = 3
M.CORNER_RADIUS       = 8
M.CELL_PAD            = 8
M.CELL_INNER_PAD_X    = 4
M.CELL_CORNER         = 6

M.ACTIVE_INSET_X      = 3
M.ACTIVE_INSET_Y      = 1
M.ACTIVE_INSET_H      = 2

M.NUMBER_W            = 14
M.FONT_SIZE           = 12
M.DIM_ALPHA           = 0.55

M.ICON_SIZE           = 16
M.ICON_GAP            = 2

M.HIDDEN_BADGE_SIZE   = 6
M.HIDDEN_BADGE_TEXT   = "\u{23F8}"
M.HIDDEN_BADGE_COLOR  = { red = 1.00, green = 0.85, blue = 0.85, alpha = 1.0 }
M.HIDDEN_BADGE_GLOW   = { red = 0.85, green = 0.10, blue = 0.10, alpha = 0.85 }
M.HIDDEN_BADGE_GLOW_R = 4
M.HIDDEN_ICON_ALPHA   = 0.55
M.HIDDEN_SEP_COLOR    = { red = 0.60, green = 0.70, blue = 0.85, alpha = 0.35 }
M.HIDDEN_SEP_WIDTH    = 1
M.HIDDEN_SEP_GAP      = 6

M.CONTAINER_BG        = { red = 0.07, green = 0.09, blue = 0.13, alpha = 0.28 }
M.CONTAINER_STROKE    = { red = 0.60, green = 0.70, blue = 0.85, alpha = 0.35 }
M.ACTIVE_CELL_BG      = { red = 0.25, green = 0.35, blue = 0.55, alpha = 0.55 }
M.ACTIVE_CELL_STROKE  = { red = 0.60, green = 0.75, blue = 0.95, alpha = 0.60 }

M.NOTCH_THRESHOLD     = 32
M.NOTCH_HALF_WIDTH    = 110
M.SCRATCH_THRESHOLD   = 10
M.HIDDEN_WORKSPACE_ID = "hidden"

M.PEEK_DELAY          = 0.10
M.PEEK_TILE_H_RATIO   = 0.16
M.PEEK_MAX_W_RATIO    = 0.60
M.PEEK_TILE_GAP       = 4
M.PEEK_MARGIN         = 6
M.PEEK_CORNER         = 8
M.PEEK_BG             = { red = 0.07, green = 0.09, blue = 0.13, alpha = 0.92 }
M.PEEK_STROKE         = { red = 0.60, green = 0.70, blue = 0.85, alpha = 0.45 }
M.PEEK_INNER_PAD      = 6
M.PEEK_TITLE_H        = 14

-- Hover tint painted below icons for the target under the cursor.
M.HOVER_FILL          = { white = 1.0, alpha = 0.10 }
M.HOVER_CORNER        = 5
M.HOVER_INSET_Y       = 2

M.RENDER_DEBOUNCE     = 0.05

return M
