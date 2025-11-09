{
  lib,
  pkgs,
  ...
}: {
  targets.genericLinux.enable = true;
  xdg = {
    enable = true;

    mime.enable = true;

    mimeApps = {
			enable = true;
			defaultApplications = {
				"text/html" = ["firefox.desktop"];
				"text/xml" = ["firefox.desktop"];
				"x-scheme-handler/http" = ["firefox.desktop"];
				"x-scheme-handler/https" = ["firefox.desktop"];
				"application/pdf" = ["org.pwmt.zathura.desktop" "firefox.desktop"];
				# "image/png" = "sxiv.desktop";
			} //
				lib.genAttrs (lib.strings.splitString ";" "image/bmp;image/gif;image/jpeg;image/jpg;image/png;image/tiff;image/x-bmp;image/x-portable-anymap;image/x-portable-bitmap;image/x-portable-graymap;image/x-tga;image/x-xpixmap")
				(scheme: ["sxiv.desktop"]);
		};

    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
      config.common.default = "*";
    };
  };
}
