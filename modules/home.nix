{ pkgs, unstable, ... }:

let
  gdk = pkgs.google-cloud-sdk.withExtraComponents( with pkgs.google-cloud-sdk.components; [
    gke-gcloud-auth-plugin
    kubectl
  ]);
in {
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
    lsof

    rustup
    unstable.bun
    unstable.nodejs_20
    unstable.nodejs_20.pkgs.pnpm
    gcc
    clang-tools
    unstable.go
    unstable.gopls

    gdk

    discord
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
