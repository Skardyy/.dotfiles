if true then return {} end

---@type LazySpec
return {
  {
    "tanvirtin/monokai.nvim",
    config = function()
      vim.cmd [[colorscheme monokai]]
      vim.cmd [[
        hi Normal guibg=None ctermbg=None
        hi ColorColumn guibg=None ctermbg=None
        hi SignColumn guibg=None ctermbg=None
        hi Folded guibg=None ctermbg=None
        hi FoldColumn guibg=None ctermbg=None
        hi CursorLine guibg=#303030 ctermbg=None
        hi CursorColumn guibg=None ctermbg=None
        hi WhichKeyFloat guibg=None ctermbg=None
        hi VertSplit guibg=None ctermbg=None
        hi DiffChange guibg=None ctermbg=None
        hi LineNr guibg=None ctermbg=None
        hi StatusLine guibg=None ctermbg=None
        hi CursorLineNr guibg=None ctermbg=None
        hi TabLineFill guibg=None ctermbg=None
        hi TabLine guibg=None ctermbg=None
        hi TabLineSel guibg=None ctermbg=None

        hi @punctuation ctermfg=white
      ]]
    end,
  },
}
