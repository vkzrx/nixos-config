{ config, lib, ... }:
with lib;
let
  cfg = config.services.bat;
in {
  options.services.bat = {
    enable = mkEnableOption "bat";
  };

  config = mkIf cfg.enable {
    programs.bat = {
      enable = true;
      config = {
        theme = "catppuccin";
      };
      themes = {
        catppuccin = builtins.readFile ../colorschemes/bat.tmTheme;
      };
    };
  };
}
