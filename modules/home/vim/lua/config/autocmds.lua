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
  callback = function()
    vim.opt_local.textwidth = 80
    vim.opt_local.formatoptions:append("t")
    vim.opt_local.formatoptions:append("a")
  end,
})
