hs.loadSpoon("SpoonInstall")

local mod = {"alt"}
local modShift = {"alt", "shift"}

spoon.SpoonInstall.repos.PaperWM = {
  url = "https://github.com/mogenson/PaperWM.spoon",
  desc = "PaperWM.spoon repository",
  branch = "release",
}

spoon.SpoonInstall:andUse("PaperWM", {
  repo = "PaperWM",
  config = {
    window_gap = 4,
    window_ratios = {0.5, 1.0},
  },
  start = true,
  hotkeys = {
    -- Focus navigation
    focus_left  = {mod, "h"},
    focus_right = {mod, "l"},
    focus_up    = {mod, "k"},
    focus_down  = {mod, "j"},
    
    -- Window movement
    swap_left  = {modShift, "h"},
    swap_right = {modShift, "l"},
    swap_up    = {modShift, "k"},
    swap_down  = {modShift, "j"},
    
    -- Position and resize
    center_window = {mod, "c"},
    full_width    = {mod, "f"},
    
    -- Column management
    slurp_in = {mod, "["},
    barf_out = {mod, "]"},
    
    -- Space switching
    switch_space_1 = {mod, "1"},
    switch_space_2 = {mod, "2"},
    switch_space_3 = {mod, "3"},
    switch_space_4 = {mod, "4"},
    switch_space_5 = {mod, "5"},
    switch_space_6 = {mod, "6"},
    switch_space_7 = {mod, "7"},
    switch_space_8 = {mod, "8"},
    switch_space_9 = {mod, "9"},
    
    -- Move window to space
    move_window_1 = {modShift, "1"},
    move_window_2 = {modShift, "2"},
    move_window_3 = {modShift, "3"},
    move_window_4 = {modShift, "4"},
    move_window_5 = {modShift, "5"},
    move_window_6 = {modShift, "6"},
    move_window_7 = {modShift, "7"},
    move_window_8 = {modShift, "8"},
    move_window_9 = {modShift, "9"},
  }
})

-- ============================================
-- CUSTOM KEYBINDINGS
-- ============================================

hs.hotkey.bind(mod, "q", function()
    local win = hs.window.focusedWindow()
    if win then 
        win:application():kill()
    end
end)

hs.hotkey.bind(mod, "return", function()
  hs.execute("open -na ghostty", true)
end)

hs.hotkey.bind(mod, "w", function()
  hs.execute("open -na 'Zen Browser'", true)
end)
