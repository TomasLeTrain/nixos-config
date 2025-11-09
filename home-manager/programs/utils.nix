{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    wl-clipboard
    jq
    unzip

    git-credential-manager

		linuxPackages.usbip
  ];

  # TODO: move
  programs.tofi = {
    enable = true;
    settings = {
      hint-font = false;
      text-cursor-style = "bar";
      border-width = 0;
      num-results = 6;

      font = "JetBrains Mono Nerd Font";
      height = "100%";

      outline-width = 0;
      padding-left = "35%";
      padding-top = "35%";
      result-spacing = 25;
      width = "100%";
    };
  };
}
