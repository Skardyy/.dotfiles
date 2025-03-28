return {
  {
    'saghen/blink.cmp',
    version = '1.*',
    opts = {
      keymap = {
        preset = 'none',
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<Tab>'] = { 'select_next', 'fallback_to_mappings' },
        ['<C-n>'] = { 'select_next', 'show', 'fallback_to_mappings' },
        ['<CR>'] = { 'accept', 'fallback' },
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      sources = {
        default = { 'lsp', 'path', 'buffer' },
      },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
      completion = {
        documentation = {
          auto_show = true,
          window = {
            border = 'rounded',
          }
        },
        menu = { border = 'rounded' },
      },
      signature = { window = { border = 'rounded' } },
    },
    opts_extend = { 'sources.default' },
  },
}
