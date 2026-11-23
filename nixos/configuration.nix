{
  config,
  lib,
  pkgs,
  nix-secrets,
  root,
  ...
}: {
  imports = [
    ./boot.nix
    ./hardware-configuration.nix
    ./graphical.nix
    ./wireguard.nix
    ./secrets.nix
  ];

  # nixpkgs.overlays = [
  #   (final: prev: {
  #   })
  # ];

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

  # local dns
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  time.timeZone = "America/New_York";
  # time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # here in case of changing keyboard options for tty
  services.xserver.xkb.options = "caps:escape";

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [
      pkgs.brlaser
      pkgs.brgenml1lpr
      pkgs.brgenml1cupswrapper
    ];
  };

  # services.joycond.enable = true;
  # services = {
  #   udev = {
  #     packages = with pkgs; [
  #       game-devices-udev-rules
  #     ];
  #   };
  # };

  hardware.uinput.enable = true;

  # for scanning from printers
  hardware.sane = {
    enable = true;

    brscan4 = {
      enable = true;
      netDevices = {
        home = {
          model = "Brother HL-L2395DW series";
          nodename = "BRNB4220024F78E.local";
        };
      };
    };

    extraBackends = [pkgs.sane-airscan];
  };

  # sound with pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  programs.zsh.enable = true;

  # automount disks
  services.udisks2.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tomas = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "dialout" "adbusers" "kvm" "scanner" "lp"];
    shell = pkgs.zsh;
    packages = with pkgs; [
      home-manager
      neovim
    ];
  };

  # for zsh completion
  environment.pathsToLink = ["/share/zsh"];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD"; # Force intel-media-driver
    # for hyprland
    NIXOS_OZONE_WL = "1";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # fallback editor
    vim

    # utils
    brightnessctl
    wget
    playerctl
    xlsclients

    # base apps
    firefox
    alacritty
    pavucontrol

    # hyprland misc
    hyprcursor
    # dunst
    # libnotify

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

    # communicating with ios device
    libimobiledevice
    ifuse
  ];

  # faster boot without waiting for network manager
  systemd.services.NetworkManager-wait-online.enable = false;

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
  };

  # services.udev.packages = [
  #   (pkgs.writeTextFile {
  #     name = "70-my-foo.rules";
  #     destination = "/etc/udev/rules.d/70-my-foo.rules";
  #     text = ''
  #       SUBSYSTEM=="usb", ATTRS{idVendor}=="8087", ATTRS{idProduct}=="0026", TAG+="uaccess"
  #     '';
  #     checkPhase = ''
  #       ${config.systemd.package}/bin/udevadm verify --resolve-names=late $out/etc/udev/rules.d/70-my-foo.rules
  #     '';
  #   })
  # ];

  # environment.systemPackages = with pkgs; [
  # ];

  # services
  # programs.dconf.enable = true;

  # also for communicating with ios device
  services.usbmuxd.enable = true;

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
        # q (multi c (macro 80 q))
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
