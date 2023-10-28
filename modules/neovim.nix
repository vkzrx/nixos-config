{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.neovim;
in {
  options.services.neovim = {
    enable = mkEnableOption "neovim";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.lua-language-server ];

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      extraPackages = [
        pkgs.nodePackages.typescript
        pkgs.nodePackages.typescript-language-server
        pkgs.nodePackages."@tailwindcss/language-server"
      ];
    };
  };
}
