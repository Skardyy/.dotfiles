return {
  "declancm/cinnamon.nvim",
  version = "*",
  config = function()
    local is_gui_mode = vim.fn.has("gui_running") == 1
    require("cinnamon").setup {
      disabled = is_gui_mode,
      keymaps = {
        basic = true,
        extra = true,
      },
      options = {
        mode = "window",
        max_delta = {
          time = 100
        }
      },
    }
  end
}
