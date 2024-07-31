-- if true then return {} end
---@type LazySpec
return {
  {
    "Skardyy/makurai-vim",
    config = function() vim.cmd [[colorscheme makurai]] end,
  },
}
