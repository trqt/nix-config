{ config, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;

    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
    };
    dotDir = ".config/zsh";
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
