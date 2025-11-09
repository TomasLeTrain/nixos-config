{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # tools
    obs-studio
    gparted
    networkmanagerapplet

		# picture stuff
		drawing
		sxiv

		# pdf viewer
    zathura
    zathuraPkgs.zathura_pdf_mupdf

    # apps
    discord

		libsForQt5.qtstyleplugin-kvantum # ??
    keepassxc libsForQt5.qt5ct

    obsidian

    speedcrunch


    kdePackages.dolphin
		# thunar

    mpv
    yt-dlp

    # development
		(lib.hiPrio gcc) # prevent conflict with clang

    clang
		clang-tools

    python312

    typst
  ];
}
