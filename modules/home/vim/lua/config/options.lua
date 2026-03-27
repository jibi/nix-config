-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Override LazyVim's colorscheme plugin to do nothing
return {
  {
    "LazyVim/LazyVim",
    opts = {
      -- don't load any colorscheme plugin
      colorscheme = nil,
    },
    config = function()
      -- force Neovim default colorscheme
      vim.cmd("colorscheme default")
      vim.opt.clipboard = "unnamedplus"
    end,
  },
  { "catppuccin/nvim", enabled = false },
  { "folke/tokyonight.nvim", enabled = false },
}
