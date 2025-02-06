return {
  "skardyy/neo-img",
  config = function()
    require('neo-img').setup({
      backend = 'magick'
    })
  end
}
