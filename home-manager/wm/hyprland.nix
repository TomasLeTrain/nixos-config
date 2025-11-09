{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # maaging backgrounds
    swww
    hyprshot
  ];

  wayland.windowManager.sway = let
    mod = "Mod4";
  in {
    enable = true;
    config = {
      modifier = mod;
      keybindings = lib.attrsets.mergeAttrsList [
        (lib.attrsets.mergeAttrsList (map (num: let
          ws = toString num;
        in {
          "${mod}+${ws}" = "workspace ${ws}";
          "${mod}+Ctrl+${ws}" = "move container to workspace ${ws}";
        }) [1 2 3 4 5 6 7 8 9 0]))

        (lib.attrsets.concatMapAttrs (key: direction: {
            "${mod}+${key}" = "focus ${direction}";
            "${mod}+Ctrl+${key}" = "move ${direction}";
          }) {
            h = "left";
            j = "down";
            k = "up";
            l = "right";
          })

        {
          "${mod}+Return" = "exec --no-startup-id ${pkgs.kitty}/bin/kitty";
          "${mod}+space" = "exec --no-startup-id wofi --show drun,run";

          "${mod}+x" = "kill";

          "${mod}+a" = "focus parent";
          "${mod}+e" = "layout toggle split";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+g" = "split h";
          "${mod}+s" = "layout stacking";
          "${mod}+v" = "split v";
          "${mod}+w" = "layout tabbed";

          "${mod}+Shift+r" = "exec swaymsg reload";
          "--release Print" = "exec --no-startup-id ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
          "${mod}+Ctrl+l" = "exec ${pkgs.swaylock-fancy}/bin/swaylock-fancy";
          "${mod}+Ctrl+q" = "exit";
        }
      ];
      focus.followMouse = false;
      startup = [
        {command = "firefox";}
      ];
      workspaceAutoBackAndForth = true;
    };
    systemd.enable = true;
    wrapperFeatures = {gtk = true;};
  };

  wayland.windowManager.hyprland = {
    enable = true;

    package = pkgs.hyprland;

    xwayland.enable = true;

    settings = {
      #variables
      "$mod" = "SUPER";

      "$terminal" = "alacritty";
      "$fileManager" = "dolphin";
      "$menu" = "$(tofi-drun --fuzzy-match true)";

      "$scripts" = "~/.config/hypr/scripts";

      monitor = [
        "eDP-1,3840x2160@60.00Hz,auto,2.5"
      ];

      env = [
        "HYPRCURSOR_THEME, catppuccin-mocha-lavender-cursors"
        "HYPRCURSOR_SIZE, 32"
      ];

      exec-once = [
        # "swww-daemon && swww img /home/tomas/wallpapers/geometric.png"
        "swww-daemon"
  		"quickshell &"
      ];

      general = {
        gaps_in = 0;
        gaps_out = 0;

        border_size = 5;

        # "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg"
        "col.active_border" = "rgba(0033ff99) rgba(aa00ff99) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false;

        allow_tearing = false;

        layout = "dwindle";
      };

      # debug = {
      #   disable_logs = false;
      #   enable_stdout_logs = true;
      # };
      render = {
        new_render_scheduling = true;
      };

      decoration = {
        rounding = 5;

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        # shadow = {
        #   enabled = true;
        #   range = 4;
        #   render_power = 3;
        #   color = "rgba(1a1a1aee)";
        # };

        blur = {
          # enabled = true
          enabled = true;
          # size = 3
          size = 20;
          passes = 1;
          xray = true;

          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;
        # first_launch_animation = false;

        bezier = [
          "windowIn, 0.06, 0.71, 0.25, 1"
          "windowResize, 0.04, 0.67, 0.38, 1"

          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"

          "workspaceBezier,0.05,0.9,0.1,1.08"
        ];

        animation = [
          # "border, 1, 5.39, easeOutQuint"
          # "borderangle, 1, 15, linear, loop"
          # "windows, 1, 2.79, easeOutQuint"
          # "windowsIn, 1, 2.1, easeOutQuint, popin 87%"

          # "windows, 1, 2.79, easeOutQuint, gnomed"
          "windowsIn, 1, 1.8, windowIn, slide"
          "windowsOut, 1, 1.8, windowIn, slide"
          "windowsMove, 1, 1.8, windowResize"
          "fade, 1, 1.5, default"

          # "fadeIn, 1, 0.04, almostLinear"
          # "fadeOut, 1, 0.04, almostLinear"
          # "fade, 1, 3.03, quick"
          # "layersIn, 1, 0.01, quick, fade"
          # "fadeLayersIn, 1, 0.1, almostLinear"

          "layers, 1, 4, windowIn, slide"

          "workspaces, 1, 2, workspaceBezier, slidevert"
        ];
      };

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle = {
        pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mod + P in the keybinds section below
        preserve_split = true; # You probably want this
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = true;
				# vfr = false;
      };

      input = {
        kb_layout = "us";
        # kb_variant =
        # kb_model =
        # kb_options = "caps:swapescape";
        # kb_rules =

        follow_mouse = 1;

        sensitivity = 0.7; # -1.0 - 1.0, 0 means no modification.
        accel_profile = "flat";

        touchpad = {
          natural_scroll = true;
          tap-and-drag = true;
        };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      gestures = {
				gesture = [
					"3, vertical, workspace"
				];
        workspace_swipe_forever = true;
        workspace_swipe_direction_lock = false;
        workspace_swipe_cancel_ratio = 0.15;
      };

      # device = [
      #   name = epic-mouse-v1
      #   sensitivity = -0.5
      # ]

      bind = [
        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        "$mod, Return, exec, $terminal"
        "$mod, semicolon, killactive,"
        "$mod, M, exit,"

        "$mod, O, exec, obsidian"

        # screenshot
        "$mod SHIFT, S, exec, hyprshot -m region --clipboard-only"

        "$mod SHIFT, Return, exec, firefox"
        "$mod CTRL, Return, exec, firefox -p school"

        "$mod, E, exec, $fileManager"
        "$mod, V, togglefloating,"
        "$mod, D, exec, $menu"
        "$mod, P, pseudo, # dwindle"
        "$mod, U, togglesplit, # dwindle"

        # Move focus with mod + arrow keys
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"

        # Switch workspaces with mod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move active window to a workspace with mod + SHIFT + [0-9]
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Scroll through existing workspaces with mod + scroll
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        "$mod SHIFT, n, exec, $scripts/vpn.sh"

        # tab back and forth
        "$mod, Tab, workspace, previous"
      ];

      # Move/resize windows with mod + LMB/RMB and dragging
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # bind = $mod SHIFT, n, exec, bash -c "pkexec systemctl stop wg-quick-wg0.service"
      # bind = $mod SHIFT, n, exec, pkexec systemctl start wg-quick-wg0.service

      # Laptop multimedia keys for volume and LCD brightness
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      # Requires playerctl
      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      layerrule = [
  		# disable animations on launcher
        "noanim, launcher"

  		# disable animation on screenshots
  		"noanim, selection"
      ];

      # Ignore maximize requests from apps. You'll probably like this.
      windowrulev2 = [
        "suppressevent maximize, class:.*"
        # disable rounding for firefox
        "rounding 0, class:^[fF]irefox"
        "rounding 0, class:^[fF]irefox"

        # Fix some dragging issues with XWayland
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    };
    # plugins = [
    #   inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
    #   # ...
    # ];
  };

  xdg.configFile."hypr/scripts/vpn.sh" = {
    executable = true;

    text = ''
      #!/usr/bin/env bash

      is_active=$(systemctl is-active wg-quick-wg0.service)

      if [[ $is_active == "active" ]]; then
          systemctl stop wg-quick-wg0.service
      else
          systemctl start wg-quick-wg0.service
      fi
    '';
  };
}
