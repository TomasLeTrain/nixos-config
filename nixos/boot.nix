{
  config,
  lib,
  pkgs,
  ...
}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = lib.strings.concatStringsSep " " [
          "${pkgs.tuigreet}/bin/tuigreet"
          "--time"
          "--asterisks"
          ''--greeting "like 67"''
          "--greet-align center"
          # "--user-menu"
          "--xsessions ${config.services.displayManager.sessionData.desktops}/share/xsessions"
          "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
          "--remember"
          # "--remember-user-session"
          "--remember-session"

          "--theme"
          (lib.strings.concatStringsSep ";" [
            "border=magenta"
            "text=cyan"
            "prompt=green"
            "time=red"
            "action=blue"
            "button=yellow"
            "container=black"
            "input=red"
          ])
          ''--cmd "uwsm start -- hyprland-uwsm.desktop"''
        ];
        user = "greeter";
      };
    };
  };

  console = {
    earlySetup = false;
    useXkbConfig = true;
    colors = [
      # TODO: make configurable
      "141415" # background
      # "252530" # black (different than background)

      "d8647e" # red
      "7fa563" # green
      "f3be7c" # yellow
      "6e94b2" # blue
      "bb9dbd" # magenta
      "aeaed1" # cyan

      "cdcdcd" # white

      "606079" # bright black

      "e08398" # bright red
      "99b782" # bright green
      "f5cb96" # bright yellow
      "8ba9c1" # bright blue
      "c9b1ca" # bright magenta
      "bebeda" # bright cyan

      "d7d7d7" # bright white
    ];
  };

  boot = {
    # Use latest kernel.
    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "uas" "sd_mod"];
      kernelModules = ["i915"];
    };

    kernelModules = ["kvm-intel"];
    extraModulePackages = [];

    kernelParams = [
      "i915.enable_guc=3"

      "quiet"
      # "splash"

      # "i915.fastboot=1"
      # "boot.shell_on_fail"

      # "loglevel=3"
      # "systemd.show_status=auto"
      # "rd.udev.log_level=3"
      # "vt.global_cursor_default=0"
    ];

    initrd.verbose = false;
    consoleLogLevel = 0;

    # using systemd boot
    loader.systemd-boot.enable = true;

    # startup animation
    plymouth = {
      enable = true;
      # theme = "double";
      # theme = "deus_ex";
      # theme = "double";
      theme = "nixos-bgrt";
      extraConfig = ''
        UseSimpledrm=1
        DeviceScale=2
        UseFirmwareBackground=false
      '';
      # logo = "${pkgs.nixos-icons}/share/icons/hicolor/48x48/apps/nix-snowflake-white.png";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = ["rings" "lone" "double" "deus_ex"];
        })
        nixos-bgrt-plymouth
      ];
    };
  };
}
