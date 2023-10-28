{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.git;
in {
  options.services.git = {
    enable = mkEnableOption "git";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      git
      gh
      lazygit
    ];

    programs.git = {
      enable = true;
      userName = "vkzrx";
      userEmail = "vkzrxw@gmail.com";
      aliases = {
        lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
        lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
      };
      extraConfig = {
        core = {
          editor = "nvim";
        };
        init = {
          defaultBranch = "main";
        };
      };
    };

    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };
  };
}
