local spinners = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }
local spinner_idx = 0
local lsp_progress_cache = ""

vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(ev)
    local value = ev.data.params.value
    if value.kind == "end" then
      vim.defer_fn(function()
        lsp_progress_cache = ""
        vim.cmd.redrawstatus()
      end, 500)
    else
      spinner_idx = (spinner_idx + 1) % #spinners
      local parts = { spinners[spinner_idx + 1] }
      if value.title and value.title ~= "" then table.insert(parts, value.title) end
      if value.message and value.message ~= "" then table.insert(parts, value.message) end
      if value.percentage then table.insert(parts, string.format("(%d%%%%)", value.percentage)) end
      lsp_progress_cache = table.concat(parts, " ")
    end
    vim.cmd.redrawstatus()
  end,
})

local function filename()
  return "%t"
end

local function modified()
  return "%m"
end

local function lsp_clients()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then return "" end
  local names = vim.tbl_map(function(c) return c.name end, clients)
  local client_str = "[" .. table.concat(names, ", ") .. "]"
  if lsp_progress_cache == "" then return client_str end
  local max_len = math.floor(vim.o.columns * 0.4)
  local msg = lsp_progress_cache
  if #msg > max_len then msg = msg:sub(1, max_len - 1) .. "…" end
  return msg .. " " .. client_str
end

local function diagnostics()
  local d = vim.diagnostic.status()
  return (d and d ~= "") and d or ""
end

local function git_branch()
  local b = vim.b.gitsigns_head
  return b or ""
end

local function git_diff()
  local d = vim.b.gitsigns_status_dict
  if not d then return "" end
  local parts = {}
  if (d.added or 0) > 0 then table.insert(parts, "%#GitSignsAdd#+" .. d.added) end
  if (d.changed or 0) > 0 then table.insert(parts, "%#GitSignsChange#~" .. d.changed) end
  if (d.removed or 0) > 0 then table.insert(parts, "%#GitSignsDelete#-" .. d.removed) end
  return #parts > 0 and (table.concat(parts, " ") .. "%*") or ""
end

local function treesitter()
  local ok, parser = pcall(vim.treesitter.get_parser, 0)
  return (ok and parser ~= nil) and "TS" or ""
end

local function position()
  return "%l:%c"
end

local function join(...)
  local result = ""
  for _, v in ipairs({ ... }) do
    if result ~= "" and v ~= "" then
      result = result .. "  " .. v
    else
      result = result .. v
    end
  end
  return result
end

_G.Statusline = function()
  local left  = join(filename() .. modified(), git_branch(), git_diff())
  local right = join(diagnostics(), lsp_clients(), treesitter(), position())
  return "  " .. left .. "%=" .. right .. "  "
end

vim.opt.statusline = "%!v:lua.Statusline()"

vim.api.nvim_create_autocmd({ "DiagnosticChanged", "BufEnter" }, {
  callback = function() vim.cmd.redrawstatus() end,
})

return {}
