{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.fish;
in {
  options.services.fish = {
    enable = mkEnableOption "fish";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fish
      fishPlugins.fzf-fish
      starship
      fd
      fzf
      ripgrep
      erdtree
    ];

    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
        '';
      shellInit = ''
        fzf_configure_bindings --directory=\cp
        set fzf_directory_opts --bind "enter:execute(nvim {} &> /dev/tty)+abort"
        set fzf_fd_opts --type f --hidden --exclude=.git
        '';
      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";
        v = "nvim";
        lg = "lazygit";
        gck="git branch --all | fzf --height 25% | xargs git checkout";
      };
      plugins = [
        { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      ];
      functions = {
        cd = {
          body = ''
            if test -z "$argv"
              builtin cd $HOME
            else
              builtin cd $argv
            end
            ls
          '';
          description = "Change directory and list content";
        };
        mk = {
          body = ''
            if test (count $argv) -eq 1
              mkdir $argv[1]; and cd $argv[1]
            else
              echo "Usage: mk <directory>"
            end
          '';
          description = "Create directory and cd into it";
        };
        cdp = {
          body = ''
            builtin cd ~/dev

            set fd_cmd (command -v fd)
            set --append fd_cmd --type directory --max-depth 1 $fzf_fd_opts

            set fzf_arguments --multi $fzf_directory_opts
            set unescaped_exp_token (string unescape -- $expanded_token)
            set --prepend fzf_arguments --prompt="Search directory" $unescaped_exp_token

            set target ($fd_cmd 2>/dev/null | _fzf_wrapper $_fzf_arguments)

            builtin cd $target
            ls
          '';
          description = "List directories at `~/dev` and cd into selected one";
        };
      };
    };

    programs.starship.enable = true;
  };
}
