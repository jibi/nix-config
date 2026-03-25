{ ... }:

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
      deploy-macbook = "nixos-rebuild switch --flake .#macbook --target-host home --build-host home --sudo";
      int_wl = "wlr-randr --output DP-2 --off --output eDP-1 --on";
      ext_wl = "wlr-randr --output eDP-1 --off --output DP-2 --on";
    };
    sessionVariables = {
      EDITOR = "nvim";
    };
    envExtra = ''
      export PATH="$HOME/bin:$PATH"
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
