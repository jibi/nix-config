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

local md_autowrap = vim.api.nvim_create_augroup("md_autowrap", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = md_autowrap,
  pattern = "markdown",
  callback = function(event)
    vim.opt_local.textwidth = 80
    vim.opt_local.formatoptions:append("t")
    vim.opt_local.formatoptions:append("a")

    vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
      group = md_autowrap,
      buffer = event.buf,
      callback = function()
        local ok, node = pcall(vim.treesitter.get_node)
        local in_code = false
        while ok and node do
          local t = node:type()
          if t == "fenced_code_block" or t == "code_fence_content" or t == "indented_code_block" then
            in_code = true
            break
          end
          node = node:parent()
        end
        local fo = vim.bo.formatoptions
        local has_t = fo:find("t") ~= nil
        local has_a = fo:find("a") ~= nil
        if in_code then
          if has_t then vim.opt_local.formatoptions:remove("t") end
          if has_a then vim.opt_local.formatoptions:remove("a") end
        else
          if not has_t then vim.opt_local.formatoptions:append("t") end
          if not has_a then vim.opt_local.formatoptions:append("a") end
        end
      end,
    })
  end,
})
