{
  config,
  pkgs,
  lib,
  nix-secrets,
  ...
}: {
  imports = [
    ./xdg.nix
    ./colors.nix

    ./wm/wm-theme.nix
    ./wm/hyprland.nix
    ./wm/niri.nix

    ./programs/programs.nix
    ./programs/utils.nix
    ./programs/terminal.nix
    ./programs/firefox.nix
    ./programs/neovim/default.nix
    ./programs/vscode.nix
    ./programs/dunst/dunst.nix

    ./programs/quickshell/quickshell.nix
  ];

  nixpkgs.overlays = [
    (final: prev: {
      vimPlugins =
        prev.vimPlugins
        // {
          cord-nvim = prev.callPackage ./cord-nvim.nix {};
        };

      # logisim-evolution = prev.logisim-evolution.overrideAttrs (old: rec {
      #   version = "5.0.0";
      #
      #   src = prev.fetchurl {
      #     url = "https://github.com/logisim-evolution/logisim-evolution/releases/download/v${version}/logisim-evolution-${version}-all.jar";
      #     hash = "sha256-azaOiUdCwEzIOqmDD4abyrAZDt5N9DrW/s24mzojpBw=";
      #   };
      # });
    })
  ];

  home.username = "tomas";
  home.homeDirectory = "/home/tomas";

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
  ];

  # fixes tofi cache being invalid
  home.activation = {
    # https://github.com/philj56/tofi/issues/115#issuecomment-1701748297
    regenerateTofiCache = lib.hm.dag.entryAfter ["writeBoundary"] ''
      tofi_cache=${config.xdg.cacheHome}/tofi-drun
      [[ -f "$tofi_cache" ]] && rm "$tofi_cache"
    '';
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "TomasLeTrain";
      user.email = "tomylopezd@gmail.com";
      credential = {
        helper = "manager";
        "https://github.com".username = "TomasLeTrain";
        credentialStore = "cache";
      };
    };
  };

  programs.home-manager.enable = true;

  news.display = "silent";

  home.stateVersion = "26.05";
}
