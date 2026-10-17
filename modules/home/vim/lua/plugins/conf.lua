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
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
      },
      formatters = {
        rustfmt = {
          condition = function(_, ctx)
            -- only use rustfmt directly when rust-analyzer is not attached
            return #vim.lsp.get_clients({ bufnr = ctx.buf, name = "rust_analyzer" }) == 0
          end,
        },
      },
    },
  },

  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        auto_attach = function(_)
          local cwd = vim.fn.getcwd()
          if vim.fn.filereadable(cwd .. "/Makefile") == 1 then
            return vim.fn.filereadable(cwd .. "/rust-project.json") == 1
          end
          return true
        end,
      },
    },
  },

  {
    "saghen/blink.cmp",
    opts_extend = {}, -- Replace source lists instead of extending LazyVim's defaults.
    opts = {
      sources = {
        default = { "lsp", "path" },
        providers = { lsp = { fallbacks = {} } },
      },
      keymap = {
        ["<CR>"] = { "fallback" },
        ["<C-y>"] = { "select_and_accept", "fallback" },
      },
      completion = {
        list = { selection = { preselect = false, auto_insert = false } },
      },
    },
  },

  {
    "godlygeek/tabular",
    cmd = { "Tabularize" },
  },
}
