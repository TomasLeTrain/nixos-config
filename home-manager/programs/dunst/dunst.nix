{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
     dunst  libnotify
  ];

  services.dunst = {
    enable = true;
		configFile = ./dunstrc;
  };
}
