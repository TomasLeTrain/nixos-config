{ pkgs, config, nix-colors, ... }: {
  imports = [
    nix-colors.homeManagerModules.default
  ];

  # colorScheme = nix-colors.colorSchemes.tokyo-night-dark;

  colorScheme = {
    slug = "vague";
    name = "vague";
    author = "vague2k";
    palette = {
      base00 = "#141415"; # background
      # ... 
      base02 = "#606079"; # bright black
      # ...

      base05 = "#cdcdcd"; # foreground
      # ...
      base06 = "#cdcdcd"; # white
      base07 = "#d7d7d7"; # bright white

      base10 = "#252530"; # black (dark background)

      base08 = "#d8647e"; # red
      base0A = "#f3be7c"; # yellow
      base0B = "#7fa563"; # green
      base0C = "#aeaed1"; # cyan
      base0D = "#6e94b2"; # blue
      base0E = "#bb9dbd"; # magenta

      base12 = "#e08398"; # bright red
      base13 = "#f5cb96"; # bright yellow
      base14 = "#99b782"; # bright green
      base15 = "#bebeda"; # bright cyan 
      base16 = "#8ba9c1"; # bright blue
      base17 = "#c9b1ca"; # bright magenta
     };
  };

  programs = {
    # kitty = {
    #   enable = true;
    #   settings = {
    #     foreground = "#${config.colorScheme.palette.base05}";
    #     background = "#${config.colorScheme.palette.base00}";
    #     # ...
    #   };
    # };

    # TODO: move to correct directory
    tofi = {
      enable = true;
      settings = {
        background-color = "#${config.colorScheme.palette.base00}99";
        foreground-color = "#${config.colorScheme.palette.base05}";

        selection-color = "#${config.colorScheme.palette.base08}";
        selection-background = "#${config.colorScheme.palette.base10}";
        selection-match-color = "#${config.colorScheme.palette.base02}";
      };
    };

    alacritty = {
      settings.colors = {
        primary = {
          background = "#${config.colorScheme.palette.base00}";
          foreground = "#${config.colorScheme.palette.base05}";
        };
        normal = {
          black   = "#${config.colorScheme.palette.base10}";
          white   = "#${config.colorScheme.palette.base06}";

          red     = "#${config.colorScheme.palette.base08}";
          yellow  = "#${config.colorScheme.palette.base0A}";
          green   = "#${config.colorScheme.palette.base0B}";
          cyan    = "#${config.colorScheme.palette.base0C}";
          blue    = "#${config.colorScheme.palette.base0D}";
          magenta = "#${config.colorScheme.palette.base0E}";
        };
        bright = {
          red     = "#${config.colorScheme.palette.base12}";
          yellow  = "#${config.colorScheme.palette.base13}";
          green   = "#${config.colorScheme.palette.base14}";
          cyan    = "#${config.colorScheme.palette.base15}";
          blue    = "#${config.colorScheme.palette.base16}";
          magenta = "#${config.colorScheme.palette.base17}";

          black = "#${config.colorScheme.palette.base02}";
          white = "#${config.colorScheme.palette.base07}";
        };
      };
    };
  };
}
