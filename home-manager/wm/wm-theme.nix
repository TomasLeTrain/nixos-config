# Theme for graphical apps
{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    (catppuccin-kvantum.override {
      accent = "lavender";
      variant = "mocha";
    })
  ];

  # Cursor setup
  home.pointerCursor = {
    name = "Catppuccin-Mocha-Lavender-Cursors";
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
      name = "catppuccin-mocha-lavender-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "lavender" ];
        size = "standard";
        variant = "mocha";
      };
    };
		# default for all versions
    iconTheme = {
			name = "Papirus lol";
			package = pkgs.papirus-icon-theme;
      # name = "Papirus-Dark";
      # package = pkgs.catppuccin-papirus-folders.override {
      #   flavor = "mocha";
      #   accent = "lavender";
      # };
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
    "org/gnome/desktop/interface" = {
      gtk-theme = "catppuccin-mocha-lavender-standard";
      color-scheme = "prefer-dark";
    };
  };

  xdg.configFile = {
    kvantum = {
      target = "Kvantum/kvantum.kvconfig";
      text = lib.generators.toINI { } {
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
  };

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    # QT_STYLE_OVERRIDE = "kvantum";
  };
}
