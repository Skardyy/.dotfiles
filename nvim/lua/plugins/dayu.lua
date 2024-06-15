-- if true then return {} end

---@type LazySpec
return {
  {
    "Skardyy/dayu-vim",
    config = function()
      vim.g.ayucolor = "soft"
      vim.cmd [[colorscheme dayu]]
    end,
  },
}
