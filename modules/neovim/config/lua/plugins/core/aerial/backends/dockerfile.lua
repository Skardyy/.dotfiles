-- backend that makes docker files treat FROM as parents
local backend_util = require("aerial.backends.util")
local backends = require("aerial.backends")
local config = require("aerial.config")

local M = {}

local ctx = { backend_name = "dockerfile", lang = "dockerfile" }

local function label(text, words)
  local line = vim.split(text, "\n", { plain = true })[1] or ""
  line = line:gsub("%s*\\%s*$", ""):gsub("^%s+", ""):gsub("%s+$", "")

  local parts = {}
  for word in line:gmatch("%S+") do
    table.insert(parts, word)
    if #parts >= (words or 3) then
      break
    end
  end
  return table.concat(parts, " ")
end

local function stage_name(node, bufnr)
  local alias, image
  for child in node:iter_children() do
    local t = child:type()
    if t == "image_alias" then
      alias = vim.treesitter.get_node_text(child, bufnr)
    elseif t == "image_spec" then
      image = vim.treesitter.get_node_text(child, bufnr)
    end
  end
  return alias or image or "FROM"
end

function M.is_supported(bufnr)
  if vim.bo[bufnr].filetype ~= "dockerfile" then
    return false, "Filetype is not dockerfile"
  end
  if not pcall(vim.treesitter.get_parser, bufnr, "dockerfile") then
    return false, "No treesitter parser for dockerfile"
  end
  return true, nil
end

function M.fetch_symbols_sync(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "dockerfile")
  if not ok or not parser then
    return backends.set_symbols(bufnr, {}, ctx)
  end
  local tree = parser:parse()[1]
  if not tree then
    return backends.set_symbols(bufnr, {}, ctx)
  end

  local items = {}
  local stage = nil

  local function keep(item)
    return not config.post_parse_symbol or config.post_parse_symbol(bufnr, item, ctx) ~= false
  end

  for node in tree:root():iter_children() do
    if node:type():match("_instruction$") then
      local sr, sc, er, ec = node:range()

      if node:type() == "from_instruction" then
        local item = {
          kind = "Class",
          name = stage_name(node, bufnr),
          level = 0,
          parent = nil,
          lnum = sr + 1,
          col = sc,
          end_lnum = er + 1,
          end_col = ec,
        }
        if keep(item) then
          stage = item
          table.insert(items, item)
        end
      else
        local item = {
          kind = "Function",
          name = label(vim.treesitter.get_node_text(node, bufnr)),
          level = stage and 1 or 0,
          parent = stage,
          lnum = sr + 1,
          col = sc,
          end_lnum = er + 1,
          end_col = ec,
        }
        if keep(item) then
          if stage then
            stage.children = stage.children or {}
            table.insert(stage.children, item)
            -- extend the stage's range to cover its instructions
            stage.end_lnum, stage.end_col = item.end_lnum, item.end_col
          else
            -- instructions before the first FROM (e.g. a bare ARG)
            item.parent = nil
            table.insert(items, item)
          end
        end
      end
    end
  end

  backends.set_symbols(bufnr, items, ctx)
end

M.fetch_symbols = M.fetch_symbols_sync

function M.attach(bufnr)
  backend_util.add_change_watcher(bufnr, "dockerfile")
end

function M.detach(bufnr)
  backend_util.remove_change_watcher(bufnr, "dockerfile")
end

return M
