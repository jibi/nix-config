-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local c_noformat_diagnostics = vim.api.nvim_create_augroup("c_noformat_diagnostics", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = c_noformat_diagnostics,
  pattern = "c",
  callback = function(event)
    vim.b[event.buf].autoformat = false
    vim.diagnostic.disable(event.buf)
  end,
})

local md_textwidth = vim.api.nvim_create_augroup("md_textwidth", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = md_textwidth,
  pattern = "markdown",
  callback = function(event)
    vim.opt_local.textwidth = 80
    vim.opt_local.formatexpr = ""

    vim.api.nvim_buf_create_user_command(event.buf, "FormatMarkdown", function()
      local parser = vim.treesitter.get_parser(event.buf, "markdown")
      local tree = parser:parse()[1]
      local root = tree:root()

      local skip = {}
      local function collect(node)
        local t = node:type()
        if t == "fenced_code_block" or t == "indented_code_block" then
          local sr, _, er, _ = node:range()
          for line = sr, er - 1 do
            skip[line] = true
          end
          return
        end
        for child in node:iter_children() do
          collect(child)
        end
      end
      collect(root)

      local total = vim.api.nvim_buf_line_count(event.buf)
      local ranges = {}
      local start = nil
      for i = 0, total - 1 do
        if skip[i] then
          if start ~= nil then
            table.insert(ranges, { start, i - 1 })
            start = nil
          end
        else
          start = start or i
        end
      end
      if start ~= nil then
        table.insert(ranges, { start, total - 1 })
      end

      for i = #ranges, 1, -1 do
        local r = ranges[i]
        vim.api.nvim_win_set_cursor(0, { r[1] + 1, 0 })
        vim.cmd(string.format("normal! V%dGgq", r[2] + 1))
      end
    end, {})
  end,
})

local prose_textwidth = vim.api.nvim_create_augroup("prose_textwidth", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = prose_textwidth,
  pattern = { "gitcommit", "text" },
  callback = function(event)
    vim.opt_local.textwidth = event.match == "gitcommit" and 72 or 80
    vim.opt_local.formatexpr = ""
  end,
})
