{ ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Pedro Vietro";
        email = "hammsvietro@gmail.com";
      };

      init.defaultBranch = "main";
      core.editor = "emacsclient -t -a ''";
    };

    signing = {
      format = "ssh";
      signByDefault = true;
      key = "~/.ssh/id_rsa.pub";
    };
  };
}
