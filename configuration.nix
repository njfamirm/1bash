# /etc/nixos/configuration.nix

{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nexim-1";
  networking.networkmanager.enable = true;
  networking.proxy.default = "http://nexim:40b9ebfa2c171e86a7646d3441a3745cbb31acc8482eedfb0dbe8d50ae83debc@46.249.100.67:8888";

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Timezone
  time.timeZone = "Asia/Tehran";

  services.xserver = {
    enable = true;
    # Enable the full GNOME desktop environment
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;

    # Keyboard layout settings remain here
    # xkb = {
    #   layout = "us,ir";
    #   options = "grp:alt_shift_toggle";
    # };
  };


  # But immediately disable the extra application sets
  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;

  # And exclude a few other non-essential packages
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
    xterm
  ];

  # Fonts
  fonts.packages = with pkgs; [
    monaspace
    # vazirmatn-font
  ];

  # Sound
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # User account
  users.users.nexim-1 = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    btop
    tree
    
    # We now only need to explicitly add packages that were disabled
    # by `services.gnome.core-apps.enable = false;` if we still want them.
    nautilus # The file manager

    # User customizations like tweaks and extensions are kept
    gnome-tweaks
    gnomeExtensions.auto-move-windows
    gnomeExtensions.blur-my-shell
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.user-themes
  ];

  # SSH service
  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Home Manager setup
  home-manager.users."nexim-1" = {
    nixpkgs.config.allowUnfree = true;
    imports = [ ./home.nix ];
  };

  # System state version
  system.stateVersion = "25.05";
}
