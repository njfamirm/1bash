{ config, pkgs, ... }:

let
  myWallpaper = pkgs.fetchurl {
    url = "https://private-user-images.githubusercontent.com/134555135/489965510-79b17e7c-8564-431a-97c0-122e018ca066.jpg?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NTgwMTQ5MTAsIm5iZiI6MTc1ODAxNDYxMCwicGF0aCI6Ii8xMzQ1NTUxMzUvNDg5OTY1NTEwLTc5YjE3ZTdjLTg1NjQtNDMxYS05N2MwLTEyMmUwMThjYTA2Ni5qcGc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwOTE2JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDkxNlQwOTIzMzBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0zOGZkY2Q4ZGM3NWRiMWU3ZWNjZGJlNzMyMWI1YjNhZDhjM2QxOTFlYWZmN2IyYWJiMTk0N2QzNDRhZDkzMzU1JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.gCzeph_tGUH0RvgBk2mepCq2eXE13V5LWLc-kQ5JtKk";
    sha256 = "sha256-isMmBpsQRDNSws1ML2Xcj20BIz8SyiPlS1eNQBA82XQ=";
  };
in
{
  home.username = "nexim-1";
  home.homeDirectory = "/home/nexim-1";

  # 1. PACKAGES
  home.packages = with pkgs; [
    # Your applications
    google-chrome
    vscode
    warp-terminal
    v2ray
    telegram-desktop
    gh

    # Theme and Wallpaper Packages
    dracula-theme
  ];
  
  # 2. THEMES & APPEARANCE
  gtk = {
    enable = true;
    theme = {
      name = "Darcula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  # 3. DCONF SETTINGS (GNOME TWEAKS)
  dconf.settings = {
    "org/gnome/desktop/background" = {
      # حالا به والپیپر دانلود شده اشاره می‌کند
      picture-uri = "file://${myWallpaper}";
      picture-uri-dark = "file://${myWallpaper}";
      picture-options = "zoomed";
    };

    # B. Shell Theme (using the User Themes extension)
    "org/gnome/shell/extensions/user-theme" = {
      name = "Darcula";
    };

    # C. Enabled Extensions
    "org/gnome/shell" = {
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "blur-my-shell@aunetx"
        "clipboard-indicator@tudmotu.com"
        "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
      ];
    };
    
    # D. Auto Move Windows Configuration
    "org/gnome/shell/extensions/auto-move-windows" = {
      application-list = [
        "dev.warp.Warp.desktop:1"
        "code.desktop:2"
        "google-chrome.desktop:3"
      ];
    };

    "org/gnome/shell/extensions/blur-my-shell" = {
      blur-panel = true;     
      blur-dash = true;    
      blur-overview = true;   
      blur-lockscreen = true;

      sigma = 30;           
      brightness = 0.6;     
    };
  };

  programs.fnm = {
    enable = true;
    # This automatically installs and sets Node.js v22 as the default.
    # You can change this or comment it out if you prefer.
    nodeJs-version = "22";
  };
  
  # Standard boilerplate
  programs.git = { enable = true; };
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}