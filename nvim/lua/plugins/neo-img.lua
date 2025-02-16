-- if true then return {} end
return {
  "Skardyy/neo-img",
  branch = "main",
  -- dir = "~/Desktop/neo-img",
  build = function()
    require("neo-img").install()
  end,
  config = function()
    require('neo-img').setup({
      size = {
        x = 1500,
      },
      offset = {
        x = 25,
      }
    })
  end
}
