{ homeBin, ... }:

{
  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;

      theme = "robbyrussell";
      plugins = [ "git" ];
    };

    shellAliases = {
      vim = "nvim";
      deploy-rpi = "nixos-rebuild switch --flake .#rpi --target-host rpi --sudo";
    };

    sessionVariables = {
      EDITOR = "nvim";
    };

    envExtra = ''
      export PATH="$HOME/${homeBin}:$PATH"
    '';

    initContent = ''
      setopt NO_HUP
      function claude() {
        command claude "$@"; printf '\e[>0u'
      }
      function gs() {
        c=$(git log -1 --format="%B") && git reset --soft HEAD~1 && git commit -a -m "$c"
      }
    '';
  };
}
