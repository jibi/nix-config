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
          condition = function(self, ctx)
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
        auto_attach = function(bufnr)
          -- Don't attach rust-analyzer in kernel module projects (Makefile in root)
          return vim.fn.filereadable(vim.fn.getcwd() .. "/Makefile") ~= 1
        end,
      },
    },
  },

  {
    "saghen/blink.cmp",
    dependencies = { "Kaiser-Yang/blink-cmp-dictionary" },
    opts = {
      sources = {
        default = { "dictionary", "lsp", "path", "snippets", "buffer" },
        providers = {
          dictionary = {
            module = "blink-cmp-dictionary",
            name = "Dict",
            min_keyword_length = 3,
            opts = {
              dictionary_files = { vim.g.dictionary_file },
            },
          },
        },
      },
    },
  },

  {
    "godlygeek/tabular",
    cmd = { "Tabularize" },
  },
}
