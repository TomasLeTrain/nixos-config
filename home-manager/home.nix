{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    ./xdg.nix
    ./colors.nix

    ./wm/wm-theme.nix
    ./wm/hyprland.nix

    ./programs/programs.nix
    ./programs/utils.nix
    ./programs/terminal.nix
    ./programs/firefox.nix
    ./programs/neovim/default.nix
    ./programs/vscode.nix

    ./programs/quickshell/quickshell.nix
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
    regenerateTofiCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      tofi_cache=${config.xdg.cacheHome}/tofi-drun
      [[ -f "$tofi_cache" ]] && rm "$tofi_cache"
    '';
  };

  programs.git = {
    enable = true;
		settings = {
			user.name  = "TomasLeTrain";
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

  home.stateVersion = "25.11";
}

