{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    inputs.quickshell.packages.x86_64-linux.default
    pkgs.eww
  ];

  # xdg.configFile.quickshell = {
  #   source = ./config;
  #   recursive = true;
  # };
  # home.file.".config/quickshell".source = "${config.home.homeDirectory}/flake/home-manager/programs/quickshell/config";
	# TODO: fix the weird self linking
  home.activation.linkMyStuff = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ln -sf $HOME/flake/home-manager/programs/quickshell/config $HOME/.config/quickshell
  '';

  # home.file.".spacemacs".source = "${config.home.homeDirectory}/where/i/keep/my/spacemacs";
}
