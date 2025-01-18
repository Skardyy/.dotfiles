return {
  "skardyy/neo-img",
  -- dir = '~/Desktop/neo-img',
  build = "cargo install viu",
  config = function()
    require('neo-img').setup()
  end
}
