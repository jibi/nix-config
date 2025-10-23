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
    };
    sessionVariables = {
      EDITOR = "nvim";
    };
    initContent = ''
      setopt NO_HUP
      function gs() {
        c=$(git log -1 --format="%B") && git reset --soft HEAD~1 && git commit -a -m "$c"
      }
    '';
  };
}
