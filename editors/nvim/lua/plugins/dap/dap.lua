local function setup_rust(dap)
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
      args = { "--port", "${port}" },
    },
  }

  dap.configurations.rust = {
    {
      name = "Launch (no args)",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.getcwd() .. "/target/debug/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
    },
    {
      name = "Launch with args",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.getcwd() .. "/target/debug/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = function()
        local args_string = vim.fn.input("Arguments: ")
        return vim.split(args_string, " ")
      end,
    },
  }
end

return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require("dap")

    -- Signs
    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition" })
    vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint" })
    vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped", linehl = "DapStoppedLine" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DapBreakpointRejected" })

    -- Language configurations
    setup_rust(dap)

    -- Keymaps
    vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Continue" })
    vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
    vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
    vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Debug: Conditional Breakpoint" })
    vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Debug: Terminate" })
  end,
}
