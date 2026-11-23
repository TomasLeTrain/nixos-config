{
  config,
  pkgs,
  lib,
  ...
}: {
  xdg.configFile."niri/config.kdl".source = ./niri_config.kdl;

  home.packages = with pkgs; [
    # maaging backgrounds
    awww
    xwayland-satellite
  ];
}
