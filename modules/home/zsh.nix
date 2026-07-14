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
      int = "wlr-randr --output DP-2 --mode 1920x1080@60Hz && wlr-randr --output eDP-1 --on && wlr-randr --output DP-2 --off";
      ext = "wlr-randr --output eDP-1 --off --output DP-2 --on";
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
