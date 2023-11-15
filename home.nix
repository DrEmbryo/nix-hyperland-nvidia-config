{ config, pkgs, ... }:

{
  home.username = "drembryo";
  home.homeDirectory = "/home/drembryo";

  home.stateVersion = "23.05";

  # packages
  home.packages = [
    # pkgs.hello
    pkgs.dolphin
  ];

  # dot files
  home.file = {
  };

  # enviroments
  home.sessionVariables = {
    # EDITOR = "emacs";
  };
  
  # programs
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      yzhang.markdown-all-in-one
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}