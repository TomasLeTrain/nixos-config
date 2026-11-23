{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # tools
    logisim-evolution
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
    vesktop

    keepassxc
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum # ??

    obsidian

    kicad

    speedcrunch

    nautilus

    kdePackages.dolphin
    kdePackages.dolphin-plugins
    udisks
    # thunar

    mpv
    yt-dlp

    # development

    arduino-ide
    arduino-cli
    esptool

    # ???
    # (lib.hiPrio llvmPackages_21.clang-tools.override {
    #   enableLibcxx = false;
    # })
    (lib.hiPrio gcc)

    # gcc # prevent conflict with clang
    clang-tools

    # llvmPackages_21.libstdcxxClang
    llvmPackages_21.libcxxClang

    (python312.withPackages (python-pkgs:
      with python-pkgs; [
        pyserial
      ]))

    typst

    moonlight-qt

    # wallpaper
    awww
    cargo-v5
  ];
}
