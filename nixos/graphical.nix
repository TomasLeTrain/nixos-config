{
  config,
  lib,
  pkgs,
  ...
}: {
  # install global fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  # xdg settings
  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };

  # sets graphical session and other related things
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

	programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # programs.uwsm.enable = true;
  # programs.uwsm.waylandCompositors = {
  #   hyprland = {
  #     prettyName = "Hyprland";
  #     comment = "Hyprland compositor managed by UWSM";
  #     binPath = "/run/current-system/sw/bin/Hyprland";
  #   };
  # };

  # polkit
  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
		enable = true;

    description = "polkit-gnome-authentication-agent-1";

    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
