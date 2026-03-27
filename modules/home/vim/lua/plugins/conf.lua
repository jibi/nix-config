return {
  {
    "nvim-mini/mini.pairs",
    enabled = false,
  },

  {
    "folke/snacks.nvim",
    opts = {
      -- indent = { enabled = false },
      scroll = { enabled = false },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        nil_ls = {
          settings = {
            ["nil"] = {
              nix = {
                flake = {
                  autoArchive = false,
                },
              },
            },
          },
        },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "default",
    },
  },

  {
    "godlygeek/tabular",
    -- Optional: If you only want to load it when calling :Tabularize
    cmd = { "Tabularize" },
  },

  --  { "hrsh7th/nvim-cmp", enabled = false },
  --  { "saghen/blink.cmp", enabled = false },
  --  { "saghen/blink.compat", enabled = false },
  --  { "hrsh7th/nvim-cmp", enabled = false },
}
