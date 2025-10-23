{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Gilberto Bertin";
        email = "me@jibi.io";
      };
      alias = {
        lg = "log --no-merges --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        dlog = "-c diff.external=difft log --ext-diff";
        dshow = "-c diff.external=difft show --ext-diff";
        ddiff = "-c diff.external=difft diff";
      };
      push.default = "current";
      diff.algorithm = "patience";
      format.signOff = true;
      init.defaultBranch = "master";
    };
  };
}
