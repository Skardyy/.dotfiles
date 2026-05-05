return {
  "amitds1997/remote-nvim.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("remote-nvim").setup()

    -- Monkey-patch _handle_provider_setup to strip ANSI escapes from PTY output
    local DevpodProvider = require("remote-nvim.providers.devpod.devpod_provider")
    local remote_nvim = require("remote-nvim")

    function DevpodProvider:_handle_provider_setup()
      if self._devpod_provider then
        self.local_provider:run_command(
          ("%s provider list --output json"):format(remote_nvim.config.devpod.binary),
          ("Checking if the %s provider is present"):format(self._devpod_provider)
        )
        local stdout = self.local_provider.executor:job_stdout()
        local raw = vim.tbl_isempty(stdout) and "{}" or table.concat(stdout, "\n")

        -- Strip ANSI/OSC escape sequences leaked from PTY
        raw = raw:gsub("\27%][^\7\27]*\7?", ""):gsub("\27%[[%d;?]*[a-zA-Z]", "")

        -- Trim to first { and last }
        local first = raw:find("{")
        local last_rev = raw:reverse():find("}")
        if first and last_rev then
          raw = raw:sub(first, #raw - last_rev + 1)
        end

        local ok, provider_list_output = pcall(vim.json.decode, raw)
        if not ok then
          provider_list_output = {}
        end

        if not vim.tbl_contains(vim.tbl_keys(provider_list_output), self._devpod_provider) then
          self.local_provider:run_command(
            ("%s provider add %s"):format(remote_nvim.config.devpod.binary, self._devpod_provider),
            ("Adding %s provider to DevPod"):format(self._devpod_provider)
          )
        end
      end
    end
  end,
}
