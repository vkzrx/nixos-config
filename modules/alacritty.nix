{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.alacritty;
in {
  options.services.alacritty = {
    enable = mkEnableOption "alacritty";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.alacritty ];

    programs.alacritty = {
      enable = true;
      settings = {
        import = ["~/dev/nixos-config/colorschemes/alacritty.yml"];
        env = {
          TERM = "xterm-256color";
        };
        window = {
          decorations = "none";
          opacity = 1.0;
        };
        font = {
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };
          size = 11.0;
        };
      };
    };
  };
}
