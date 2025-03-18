-- if true then return {} end
return {
  "Skardyy/neo-img",
  -- branch = "macos-fix",
  dir = "~/Desktop/neo-img",
  build = ":NeoImg Install",
  config = function()
    require('neo-img').setup({
      -- backend = "iterm",
    })
  end
}
