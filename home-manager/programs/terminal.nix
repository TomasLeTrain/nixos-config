{
  lib,
  config,
  pkgs,
  ...
}: {
  # terminal related applications
  home.packages = with pkgs; [
    neofetch
    fzf
    htop
    btop
    bluetui

    tmux

    # for zsh
    zsh-fast-syntax-highlighting
  ];

  programs.bash = {
    enable = true;
  };

  programs.zsh = {
    enable = true;

    plugins = [
      # {
      #   name = "zsh-nix-shell";
      #   file = "nix-shell.plugin.zsh";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "chisui";
      #     repo = "zsh-nix-shell";
      #     rev = "v0.8.0";
      #     sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
      #   };
      # }
    ];

    shellAliases = {
      start_vpn = "sudo systemctl start wg-quick-wg0.service";
      stop_vpn = "sudo systemctl stop  wg-quick-wg0.service";
      home = "home-manager switch --flake /home/tomas/flake/#tomas@nixbtw";
      nixos = "sudo nixos-rebuild switch --flake /home/tomas/flake/#nixbtw";
      nd = "nix develop";
      ns = "nix-shell";

      cf = "g++ -Wall -Wextra -Wshadow -D_GLIBCXX_ASSERTIONS -DDEBUG -ggdb3 -fmax-errors=2 -std=c++17 -o out";
      ca = "g++ -Wall -Wextra -Wshadow -Wno-sign-conversion -fsanitize=address,undefined -D_GLIBCXX_ASSERTIONS -DDEBUG -ggdb3 -fmax-errors=2 -std=c++17 -o out";

      cfd = "g++ -Wall -Wextra -Wshadow -Wformat=2 -Wfloat-equal -Wconversion -Wlogical-op -Wshift-overflow=2 -Wduplicated-cond -Wcast-qual -Wcast-align -Wno-sign-conversion -fsanitize=address,undefined -fno-sanitize-recover -fstack-protector -D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC -D_FORTIFY_SOURCE=2 -D_GLIBCXX_ASSERTIONS -DDEBUG -ggdb3 -O2 -fmax-errors=2 -std=c++17 -o out";

      cfn = "g++ -std=c++17 -o out";
      cfr = "./out";
      cfcomp = "cd ~/cf/comps";
      cfdaily = "cd ~/cf/daily";

      usbbrain = "sudo modprobe vhci_hcd && sudo usbip attach -r robot.local -b 1-1";
    };

    history.size = 10000;

    autosuggestion = {
      enable = true;
    };

    completionInit = "autoload -U compinit && zmodload zsh/complist && compinit";

    initContent = let
      load_colors = lib.mkOrder 500 "autoload -U colors && colors";
      load_edit_command_line = lib.mkOrder 500 ''
        autoload edit-command-line
        zle -N edit-command-line

      '';
      binds = lib.mkOrder 500 ''
            bindkey -e
            bindkey '\C-xe' edit-command-line
        bindkey -s '\el' 'ls\n' # esc-l runs ls
      '';

      autocomplete_opt = "_comp_options+=(globdots)";

      prompt = lib.mkOrder 1200 ''
        PS1="%{$fg[magenta]%}%~%{$fg[red]%} %{$reset_color%}$%b "
      '';
      ignore_list = "export HISTIGNORE='exit:cd:ls:bg:fg:history:f:fd:vim'";

      source_syntax_highlighting = lib.mkAfter "source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
    in
      lib.mkMerge [load_colors autocomplete_opt binds load_edit_command_line prompt ignore_list source_syntax_highlighting];
  };

  programs.kitty = {
    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";

      font_family = "JetBrainsMono NF";
      font_size = "17.0";
      background_opacity = "0.9";
      paste_actions = "quote-urls-at-prompt,confirm-if-large";

      touch_scroll_multiplier = "6.0";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        live_config_reload = true;
      };

      font = {
        normal.family = "JetBrains Mono Nerd Font";
        size = 17;
      };

      # env.TERM = "xterm-256color";

      window = {
        opacity = 0.6;
        decorations = "none";
        dynamic_padding = true;

        padding = {
          x = 0;
          y = 0;
        };
      };
    };
  };

  xdg.configFile."scripts/tmux-sessionizer.sh" = let
    directories = lib.strings.concatStringsSep " " [
      "~/"
      "~/school"
      "~/projects"
      "~/projects/Robotics"
      "~/projects/Robotics/current"
      "~/projects/Robotics/current/libs"
    ];
  in {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      if [[ $# -eq 1 ]]; then
          selected=$1
      else
          selected=$(find ${directories} -mindepth 1 -maxdepth 1 -type d | \
              sed "s|^$HOME/||" | \
							fzf --tmux 60% --style=minimal --color=bg+:16
          )
          # Add home path back
          if [[ -n "$selected" ]]; then
              selected="$HOME/$selected"
          fi
      fi

      if [[ -z $selected ]]; then
          exit 0
      fi

      selected_name=$(basename "$selected" | tr . _)
      tmux_running=$(pgrep tmux)

      if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
          tmux new-session -s $selected_name -c $selected
          exit 0
      fi

      if ! tmux has-session -t=$selected_name 2> /dev/null; then
          tmux new-session -ds $selected_name -c $selected
          # select first window
          tmux select-window -t $selected_name:1
      fi

      tmux switch-client -t $selected_name
    '';
  };

  programs.tmux = let
    sessionizer = "~/.config/scripts/tmux-sessionizer.sh";
    # sessionizer = "tms";
  in {
    enable = true;

    # mouse = false;
    escapeTime = 0;
    baseIndex = 1;
    shortcut = "b";

    keyMode = "vi";
    historyLimit = 50000;

    extraConfig = ''
      # allows passthrough of keys?
      set-option -g allow-passthrough on

      # color-related options
      set -g default-terminal "tmux-256color"
      set -ga terminal-features ",*:usstyle" # Enable undercurl and color.
      set -gs terminal-overrides ",*:RGB" # Support RGB color with SGR escape sequences.

      # set-option remain-on-exit on
      set -g renumber-windows on   # renumber all windows when any window is closed

      # recommended for nvim
      set-option -g focus-events on

      # style
      set -g status-position top
      set -g status-justify absolute-centre
      set -g status-style 'fg=color7 bg=default'
      # set -g status-right '''
      set -g status-right ' #(cd #{pane_current_path}; git rev-parse --abbrev-ref HEAD)'
      set -g status-left '#S'
      set -g status-left-style 'fg=color8'
      set -g status-right-length 0
      set -g status-left-length 100
      setw -g window-status-current-style 'fg=colour5 bg=default bold'
      setw -g window-status-current-format '#I:#W '
      setw -g window-status-style 'fg=color8 bg=default'

      # vim-like pane switching
      bind -r ^ last-window
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R

      # Scripts that are baked into tmux
      bind G new-window -n 'lazygit' lazygit
      bind-key f run-shell "tmux neww ${sessionizer}"
      # bind-key -r N run-shell "${sessionizer} ~/documents/notes"
      # bind-key -r P run-shell "${sessionizer} ~/documents/projects"
      # bind-key -r H run-shell "${sessionizer} ~"
      bind-key -r D run-shell "${sessionizer} ~/flake"
      bind-key -r J run-shell "${sessionizer} ~/projects/Robotics/"
      bind-key b set-option status
    '';
  };
}
