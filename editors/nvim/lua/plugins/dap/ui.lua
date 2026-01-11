return {
  "igorlfs/nvim-dap-view",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  config = function()
    local dap = require("dap")
    local dapview = require("dap-view")

    dapview.setup({
      winbar = {
        sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
      },
      windows = {
        size = 0.35,
        position = "below",
      },
    })

    dap.listeners.after.event_initialized["dapview_config"] = function()
      dapview.open()
    end
    dap.listeners.before.event_terminated["dapview_config"] = function()
      dapview.close()
    end
    dap.listeners.before.event_exited["dapview_config"] = function()
      dapview.close()
    end

    vim.keymap.set("n", "<leader>dv", dapview.toggle, { desc = "Debug: Toggle View" })
  end,
}
