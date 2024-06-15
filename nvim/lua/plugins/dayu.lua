-- if true then return {} end

---@type LazySpec
return {
  {
    "Skardyy/dayu-vim",
    config = function() vim.cmd [[colorscheme dayu]] end,
  },
}
