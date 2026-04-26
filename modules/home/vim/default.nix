# code snippet from: https://github.com/LazyVim/LazyVim/discussions/1972
{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;

    # Tools and LSP servers available on $PATH for Neovim.
    extraPackages = with pkgs; [
      # general dependencies
      git
      lazygit
      ripgrep
      fzf
      fd
      tree-sitter # treesitter cli

      # Language Servers (make sure to install these,
      # they can easily be configured via the extras available
      # for many languages: https://www.lazyvim.org/extras)
      # luA
      lua-language-server
      stylua

      # nix
      nil
      nixfmt
      statix

      # c
      clang-tools

      # json
      vscode-langservers-extracted

      # toml
      taplo

      # rust
      rust-analyzer

      # haskell
      haskell-language-server
      fourmolu
      hlint

      # sh
      shfmt

      # Dictionary
      scowl
    ];

    # Only lazy-nvim itself is loaded as a Neovim plugin.
    plugins = with pkgs.vimPlugins; [ lazy-nvim ];

    initLua =
      # if treesitter is configured correctly,
      # the follwing language-hint will cause the embedded language
      # to be highlighted correctly:
      # lua
      let
        treesitter = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;

        # NOTE: when using only a few treesitter grammars, make sure
        # to clear ensure_installed in nvim-treesitter (see below)
        # treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
        #   p.lua
        #   p.nix
        # ]);

        # Collect all grammar derivations into a single directory
        # so nvim-treesitter can find them via install_dir
        treesitterGrammars = pkgs.symlinkJoin {
          name = "nvim-treesitter-grammars";
          paths = treesitter.dependencies;
        };

        # List of all plugins that you want to use.
        # These get turned into a linkFarm directory that Lazy uses
        # as its dev.path (see below).
        plugins = with pkgs.vimPlugins; [
          blink-cmp
          blink-cmp-dictionary
          bufferline-nvim
          conform-nvim
          flash-nvim
          friendly-snippets
          gitsigns-nvim
          grug-far-nvim
          lazydev-nvim
          lazy-nvim
          LazyVim
          lualine-nvim
          mini-ai
          mini-icons
          mini-pairs
          noice-nvim
          nui-nvim
          nvim-lint
          nvim-lspconfig
          nvim-treesitter
          nvim-treesitter-textobjects
          nvim-ts-autotag
          persistence-nvim
          plenary-nvim
          snacks-nvim
          todo-comments-nvim
          trouble-nvim
          ts-comments-nvim
          which-key-nvim
          tabular
          SchemaStore-nvim
          clangd_extensions-nvim
          haskell-tools-nvim
        ];

        # Maps a plugin derivation to a { name, path } pair.
        # linkFarm expects this format to create a directory of symlinks
        # where each plugin is accessible by its name.
        mkEntryFromDrv =
          drv:
          if lib.isDerivation drv then
            {
              name = "${lib.getName drv}";
              path = drv;
            }
          else
            drv;

        # Creates a directory with symlinks to all plugins, keyed by name.
        # This is what Lazy uses as its local plugin source via dev.path.
        lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
      in
      # lua
      ''
        require("lazy").setup({
          defaults = {
            lazy = false,
          },
          dev = {
            -- reuse files from pkgs.vimPlugins.*
            path = "${lazyPath}",
            patterns = { "." },
            -- if a plugin isn't found in the linkFarm,
            -- Lazy will fall back to downloading it directly
            fallback = true,
          },
          spec = {
            { "LazyVim/LazyVim", import = "lazyvim.plugins" },

            { import = "lazyvim.plugins.extras.lang.clangd" },
            { import = "lazyvim.plugins.extras.lang.json" },
            { import = "lazyvim.plugins.extras.lang.toml" },
            { import = "lazyvim.plugins.extras.lang.rust" },
            { import = "lazyvim.plugins.extras.lang.haskell" },

            -- disable mason.nvim, use programs.neovim.extraPackages
            { "mason-org/mason-lspconfig.nvim", enabled = false },
            { "mason-org/mason.nvim", enabled = false },

            -- import/override with your plugins
            { import = "plugins" },

            -- since mason is disabled, each server needs to be explicitly
            -- configured here so nvim-lspconfig picks it up without mason
            { "neovim/nvim-lspconfig", opts = { servers = { lua_ls = {}, nil_ls = {} } } },

            -- make sure nvim-treesitter is configured last,
            -- if you dont want to install all grammars you might
            -- need to use a function for ensure_installed to
            -- clear it
            {
              "nvim-treesitter/nvim-treesitter",
              -- dont run anything when installing/updating
              build = "",
              -- NOTE: when not all grammars are installed, make sure
              -- to clear encure_installed by making opts a function:
              -- opts = function(_, opts)
              --   opts.ensure_installed = {}
              --   opts.install_dir = "${treesitterGrammars}"
              --   return opts
              -- end,
              opts = {
                install_dir = "${treesitterGrammars}",
              },
            },
          },
          checker = { enabled = true, notify = false },
          performance = {
            rtp = {
              disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
              },
            },
          },
        })

        vim.g.snacks_animate = false
        vim.g.dictionary_file = "${pkgs.scowl}/share/dict/words.txt"
      '';
  };

  xdg.configFile."nvim/lua" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/home/vim/lua";
  };
}
