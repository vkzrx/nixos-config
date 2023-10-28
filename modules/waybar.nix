{ config, unstable, lib, ... }:
with lib;
let
  cfg = config.services.waybar;
in {
  options.services.waybar = {
    enable = mkEnableOption "waybar";
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      package = unstable.waybar.overrideAttrs(oldAttrs: {
        mesonFlags = (oldAttrs.mesonFlags or []) ++ [ "-Dexperimental=true" ];
        patches = (oldAttrs.patches or []) ++ [
          (unstable.fetchpatch {
           name = "fix waybar hyprctl";
           url = "https://aur.archlinux.org/cgit/aur.git/plain/hyprctl.patch?h=waybar-hyprland-git";
           sha256 = "sha256-pY3+9Dhi61Jo2cPnBdmn3NUTSA8bAbtgsk2ooj4y7aQ=";
           })
        ];
      });
      style = ''
        ${builtins.readFile ../colorschemes/waybar.css}

        * {
          color: @text;
          border: none;
        }

        window#waybar {
          background: transparent
        }

        button:hover {
          background: transparent;
          box-shadow: unset;
        }

        #workspaces button.active {
          background-color: shade(@surface1, 0.9);
        }
      '';
      settings = [{
        layer = "top";
        position = "top";
        height = 34;
        spacing = 14;
        margin-right = 12;
        modules-left = [ "hyprland/workspaces" ];
        modules-right = [
          "cpu"
          "memory"
          "network"
          "pulseaudio"
          "battery"
          "clock"
        ];
        "hyprland/workspaces" = {
        };
        cpu = {
          format = "CPU {usage}%";
          tooltip = false;
        };
        memory = {
          format = "MEM {}%";
        };
        network = {
          interval = 1;
          format = "{essid}";
          format-alt = "{icon} {ipaddr}/{cidr}";
          format-disconnected = "Disconnected ⚠";
          format-ethernet = "{icon} {essid}";
          format-linked = "{essid} (No IP)";
          format-wifi = "{icon} {essid}";
          format-icons = [" "];
          tooltip = false;
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} ";
          format-muted = "";
          format-icons = {
            default = [ "" "" " " ];
            headphones = "";
            phone = "";
            portable = "";
          };
        };
        battery = {
          format = "⚡ {capacity}%";
        };
        clock = {
          interval = 60;
          format= "{:%H:%M}";
          format-alt = "{:%A %d %B}";
          tooltip = false;
          max-length = 25;
        };
      }];
    };
  };
}
