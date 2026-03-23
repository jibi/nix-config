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
    };
    sessionVariables = {
      EDITOR = "nvim";
    };
    envExtra = ''
      export PATH="$HOME/bin:$PATH"
    '';
    initContent = ''
      setopt NO_HUP
      function gs() {
        c=$(git log -1 --format="%B") && git reset --soft HEAD~1 && git commit -a -m "$c"
      }
    '';
  };
}
