# Theme for graphical apps
{
  lib,
  pkgs,
  ...
}: let
  qtctSettings = {
    #	[Appearance]
    # color_scheme_path=/home/tomas/.config/qt6ct/style-colors.conf
    # custom_palette=true
    # icon_theme=breeze-dark
    # standard_dialogs=default
    # style=kvantum-dark
    #
    # [Fonts]
    # fixed="DejaVu Sans,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0"
    # general="DejaVu Sans,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0"
    #
    # [Interface]
    # activate_item_on_single_click=1
    # buttonbox_layout=0
    # cursor_flash_time=1000
    # dialog_buttons_have_icons=1
    # double_click_interval=400
    # gui_effects=@Invalid()
    # keyboard_scheme=2
    # menus_have_icons=true
    # show_shortcuts_in_context_menus=true
    # stylesheets=@Invalid()
    # toolbutton_style=4
    # underline_shortcut=1
    # wheel_scroll_lines=3
    #
    # [SettingsWindow]
    # geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\x5\0\0\0\0\0\0\0\f\"\0\0\x4\x11\0\0\x5\0\0\0\0\0\0\0\f\"\0\0\x4\x11\0\0\0\x1\x2\0\0\0\a\x80\0\0\x5\0\0\0\0\0\0\0\f\"\0\0\x4\x11)
    #
    # [Troubleshooting]
    # force_raster_widgets=1
    # ignored_applications=@Invalid()
    #
    Appearance = {
      style = "kvantum";
      icon_theme = "Papirus-Dark";
      custom_palette = true;
      color_scheme_path =
        "${pkgs.catppuccin-qt5ct}/share/qt5ct/colors/"
        + "catppuccin-mocha-lavender.conf";
    };
  };
in {
  home.packages = with pkgs; [
    (catppuccin-kvantum.override {
      accent = "lavender";
      variant = "mocha";
    })
  ];

  # Cursor setup
  home.pointerCursor = {
    name = "catppuccin-mocha-lavender-cursors";
    package = pkgs.catppuccin-cursors.mochaLavender;
    gtk.enable = true;
    size = 32;
  };

  # GTK Setup
  gtk = {
    enable = true;
    colorScheme = "dark";
    # default for gtk 2/3
    theme = {
      name = "Tokyonight-Dark";
      package = pkgs.tokyonight-gtk-theme.override {
        colorVariants = ["dark"];
        sizeVariants = ["standard"];
        themeVariants = ["default"];
        tweakVariants = ["black"];
        iconVariants = ["Dark"];
      };
      # package = pkgs.adwaita;
      # name = "catppuccin-mocha-lavender-standard";
      # package = pkgs.catppuccin-gtk.override {
      #   accents = ["lavender"];
      #   size = "standard";
      #   variant = "mocha";
      # };
    };
    # default for all versions
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "lavender";
      };
    };
    # default for all versions
    cursorTheme = {
      name = "catppuccin-mocha-lavender-cursors";
      package = pkgs.catppuccin-cursors.mochaLavender;
    };

    gtk3 = {
      bookmarks = [
        "file:///home/tomas/school"
        "file:///home/tomas/projects"
        "file:///home/tomas/projects/Robotics"
        "file:///home/tomas/Downloads"
        "file:///home/tomas/Downloads/school"
        "file:///home/tomas/Documents"
        "file:///home/tomas/tmp"
      ];
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
    gtk4.theme = null;
  };

  dconf.settings = {
    "org/gtk/settings/file-chooser" = {
      sort-directories-first = true;
    };

    # GTK4 Setup
    # "org/gnome/desktop/interface" = {
    #   gtk-theme = "catppuccin-mocha-lavender-standard";
    #   color-scheme = "prefer-dark";
    # };
  };

  xdg.configFile = {
    kvantum = {
      target = "Kvantum/kvantum.kvconfig";
      text = lib.generators.toINI {} {
        General.theme = "catppuccin-mocha-lavender";
      };
    };

    "Kvantum/catppuccin-mocha-lavender".source = "${pkgs.catppuccin-kvantum.override {
      accent = "lavender";
      variant = "mocha";
    }}/share/Kvantum/catppuccin-mocha-lavender";
  };

  # enable qt
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
    qt5ctSettings = qtctSettings;
    qt6ctSettings = qtctSettings;
  };

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
  };
}
