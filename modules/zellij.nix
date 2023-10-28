{ config, lib, pkgs, unstable, ... }:
with lib;
let
  cfg = config.services.zellij;
in {
  options.services.zellij = {
    enable = mkEnableOption "zellij";
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      package = unstable.zellij;
      enableFishIntegration = true;
    };
  };
}
