{ pkgs, unstable, ... }:

{
  imports = [
    ./waybar.nix
    ./alacritty.nix
    ./fish.nix
    ./tmux.nix
    ./zellij.nix
    ./neovim.nix
    ./git.nix
    ./bat.nix
  ];

  home.stateVersion = "23.05";

  home.username = "vkzrx";

  home.packages = with pkgs; [
    htop
    cliphist
    xclip
    unzip
    jq
    file

    rustup
    unstable.bun
    unstable.nodejs_20
    unstable.nodejs_20.pkgs.pnpm
    gcc
    clang-tools
    unstable.go
    unstable.gopls
  ];

  programs.home-manager.enable = true;

  services = {
    waybar.enable = true;
    alacritty.enable = true;
    fish.enable = true;
    tmux.enable = false;
    zellij.enable = true;
    neovim.enable = true;
    git.enable = true;
    bat.enable = true;
  };
}
