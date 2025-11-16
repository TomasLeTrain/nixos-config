{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./boot.nix
    ./hardware-configuration.nix
    ./graphical.nix
    # ./wireguard.nix
  ];

	# optimize store sizes
  nix.optimise.automatic = true;
  nix.optimise.dates = ["15:00"]; # 3pm

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking.hostName = "nixbtw";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # here in case of changing keyboard options for tty
  services.xserver.xkb.options = "caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # sound with pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tomas = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "dialout"]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree # what does this do?
      home-manager
      neovim
    ];
  };

  # for zsh completion
  environment.pathsToLink = ["/share/zsh"];

  environment.sessionVariables = {
    # LIBVA_DRIVER_NAME = "iHD"; # Force intel-media-driver
    # for hyprland
    NIXOS_OZONE_WL = "1";
  };

  # programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    vim

    # utils
    brightnessctl
    wget
    playerctl
    xorg.xlsclients

    # base apps
    firefox
    alacritty
    pavucontrol

    eww
    swww
    tofi

    # hyprland misc
    hyprcursor
    dunst
    libnotify

    # wayland
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    qt5.qtwayland
    qt6.qmake
    qt6.qtwayland

    polkit_gnome

    # system
    linux-firmware
    libva-utils
    bluez-tools
    bluez-alsa

    upower

    # theming things
    # libsForQt5.qtstyleplugin-kvantum
    # libsForQt5.qt5ct # Magic for some Qt apps keep functionality. KeepassXC
    #                  # needs it to be able to minimize to tray. See
    #                  # https://wiki.archlinux.org/title/Wayland#Qt
  ];

  systemd.services.NetworkManager-wait-online.enable = false;

  # services
  # programs.dconf.enable = true;
  services.upower.enable = true;

  services.thermald.enable = true;

  services.auto-cpufreq.enable = true;

  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "auto";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  services.kanata = {
    enable = true;
    keyboards = {
      caps_esc_remap = {
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defsrc
          	caps esc)

          (deflayermap (default-layer)
          	;; tap caps lock as esc, hold caps lock as left control
          	caps (tap-hold-press 130 130 esc lctl)
          	esc (tap-hold 200 200 esc caps)
          	)
        '';
      };
    };
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
