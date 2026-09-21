{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
let
  mkBind = key: cmd: {
    _args = [
      key
      (lib.generators.mkLuaInline "hl.dsp.${cmd}")
    ];
  };
  mkMouseBind = key: cmd: {
    _args = [
      key
      (lib.generators.mkLuaInline "hl.dsp.${cmd}")
      { mouse = true; }
    ];
  };
  mkBindExec = key: cmd: (mkBind key ''exec_cmd("${cmd}")'');
  mkBindIPC = key: cmd: (mkBindExec key "noctalia msg ${cmd}");
  mkExec =
    cmd:
    lib.generators.mkLuaInline ''
      function()
        hl.exec_cmd("${cmd}")
      end
    '';
  #mkFunction = body: lib.generators.mkLuaInline ''
  #  function()
  #    ${body}
  #  end
  #'';
  mkWorkspace = num: {
    workspace = num;
    monitor = "eDP-1";
    persistent = true;
  };
  mkFocusWorkspace = i: mkBind "SUPER + ${toString i}" "focus({ workspace = ${toString i} })";
  mkMoveWorkspace =
    i: mkBind "SUPER + SHIFT + ${toString i}" "window.move({ workspace = ${toString i} })";
  mkMoveDir = key: dir: mkBind "SUPER + SHIFT + ${key}" "window.move({ direction = \"${dir}\" })";

  qtSettings = {
    Appearance = {
      icon_theme = "Papirus-Dark";
      style = "Fusion";
      color_scheme_path = "${config.home.homeDirectory}/.config/qt6ct/colors/noctalia.conf";
      custom_palette = true;
    };
    Fonts = {
      general = "JetBrains Mono Nerd Font,10,-1,5,50,0,0,0,0,0";
    };
    Interface = {
      cursor_theme = "Bibata-Modern-Ice";
    };
  };
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # home.packages = with pkgs; [
  #   # adw-gtk3
  #   papirus-icon-theme
  #   papirus-folders
  # ];

  #programs.kitty.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";

    settings = {
      #mod = {
      #  _var = "SUPER";
      #};
      config = {
        general = {
          gaps_in = 5;
          gaps_out = 10;
        };

        decoration = {
          rounding = 8;
          rounding_power = 2;

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "0xee1a1a1a";
          };

          blur = {
            enabled = true;
            size = 2;
            passes = 2;
            vibrancy = 0.1696;
          };
        };

        input = {
          touchpad.natural_scroll = true;
          natural_scroll = true;

          kb_layout = "us";
          kb_variant = "intl";
        };

        # misc.force_default_wallpaper = 0;
        misc = {
          disable_splash_rendering = true;
          disable_hyprland_logo = true;
        };
      };

      gesture = {
        fingers = 3;
        direction = "horizontal";
        action = "workspace";
      };

      # monitor = {
      #   output = "eDP-1";
      #   mode = "1920x1080@60.01Hz";
      #   position = "0x0";
      #   scale = 1.25;
      # };

      on = {
        _args = [
          "hyprland.start"
          (mkExec "noctalia")
          #(lib.generators.mkLuaInline ''
          #  function()
          #    hl.exec_cmd("noctalia")
          #  end
          #'')
        ];
      };

      bind = [
        # General
        (mkBind "SUPER + Q" "window.close()")
        (mkBind "SUPER + F" "window.fullscreen()")
        (mkBind "SUPER + M" ''workspace.toggle_special("music")'')

        # Applications/Tools
        (mkBindExec "SUPER + T" "foot")
        (mkBindExec "SUPER + W" "helium")
        (mkBindExec "SUPER + E" "thunar")
        (mkBindExec "SUPER + C" "code")
        (mkBindExec "SUPER + O" "obsidian")
        (mkBindExec "SUPER + P" "drawing")
        (mkBindExec "SUPER + D" "discord")
        (mkBindExec "SUPER + S" ''grim -g \"$(slurp -d)\" - | wl-copy'')
        (mkBindExec "SUPER + SHIFT + S" ''grim -g \"$(slurp -d)\" - | satty -f - --copy-command wl-copy -o \"~/Pictures/Screenshots/%Y%m%d_%H%M%S.png\"'')

        # Recommended Noctalia base keybinds
        (mkBindIPC "SUPER + Space" "panel-toggle launcher")
        (mkBindIPC "SUPER + period" "panel-toggle control-center")
        (mkBindIPC "SUPER + comma" "settings-toggle")
        (mkBindIPC "ALT + Tab" "window-switcher")

        # Noctalia brightness/volume keybinds
        (mkBindIPC "SUPER + UP" "volume-up")
        (mkBindIPC "SUPER + DOWN" "volume-down")
        (mkBindIPC "SUPER + LEFT" "brightness-up")
        (mkBindIPC "SUPER + RIGHT" "brightness-down")

        # Workspace switching
        (mkFocusWorkspace 1)
        (mkFocusWorkspace 2)
        (mkFocusWorkspace 3)
        (mkFocusWorkspace 4)
        (mkFocusWorkspace 5)

        # Move active window to workspace
        (mkMoveWorkspace 1)
        (mkMoveWorkspace 2)
        (mkMoveWorkspace 3)
        (mkMoveWorkspace 4)
        (mkMoveWorkspace 5)

        # Rearrange windows within workspace
        (mkMoveDir "LEFT" "left")
        (mkMoveDir "RIGHT" "right")
        (mkMoveDir "UP" "up")
        (mkMoveDir "DOWN" "down")

        # Mouse window binds (Move & Resize)
        (mkMouseBind "SUPER + mouse:272" "window.drag()")
        (mkMouseBind "SUPER + mouse:273" "window.resize()")

        # This doesn't work: Swap current split orientation between vertical and horizontal
        #(mkBind "SUPER + J" "layout(\"swapsplit\")")

        #(mkBind "SUPER + T" "kitty")
        #(mkBind "SUPER + Space" "noctalia-launcher")
      ];

      workspace_rule = [
        (mkWorkspace 1)
        (mkWorkspace 2)
        (mkWorkspace 3)
        (mkWorkspace 4)
        (mkWorkspace 5)
        {
          workspace = "special:music";
          on_created_empty = "spotify";
        }
      ];

      window_rule = [
        {
          match.class = "dev.noctalia.Noctalia";
          float = true;
          size = [
            600
            800
          ];
        }
        # {
        #   match.class = "spotify";
        #   workspace = "special:music";
        # }
      ];

      layer_rule = {
        name = "noctalia";
        match = {
          namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$";
        };
        no_anim = true;
        ignore_alpha = 0.5;
        blur = true;
        blur_popups = true;
      };

      env = [
        {
          _args = [
            "QT_QPA_PLATFORMTHEME"
            "qt5ct"
          ];
        }
        {
          _args = [
            "QT_QPA_PLATFORMTHEME"
            "qt6ct"
          ];
        }
      ];
    };
    extraConfig = ''
      local noctaliaPath = os.getenv("HOME") .. "/.config/hypr/noctalia.lua"
      local file = io.open(noctaliaPath, "r")

      if file then
          file:close()
          local chunk, err = loadfile(noctaliaPath)
          if chunk then
              local success, result = pcall(chunk)
              if success then
                  if type(result) == "table" and type(result.apply_theme) == "function" then
                      result.apply_theme()
                  elseif type(result) == "function" then
                      result()
                  end
              else
                  print("Error executing noctalia.lua: " .. tostring(result))
              end
          else
              print("Error loading noctalia.lua: " .. tostring(err))
          end
      end
    '';
  };

  # Hint Electron apps to use Wayland
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.noctalia = {
    enable = true;
    #settings = {
    #  theme = {
    #    mode = "dark";
    #    source = "wallpaper";
    #  };
    #  wallpaper = {
    #    enabled = true;
    #    default.path = "~/Pictures/Wallpapers/wallhaven-ymz61d.jpg";
    #  };
    #  brightness.monitor.eDP-1 = {
    #    backend = "backlight";
    #    backlight_device = "amdgpu_bl1";
    #  };
    #};
  };
  xdg.configFile."noctalia/config.toml".source = ./noctalia.toml;

  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Make GTK and Qt apps look good
  # GTK Configuration
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 10;
    };
  };

  # Qt Configuration for cross-toolkit consistency
  qt = {
    enable = true;
    # style.name = "fusion"; # Or kvantum depending on preference
    # platformTheme.name = "gtk"; # Forces Qt apps to follow GTK/GNOME settings
    qt6ctSettings = qtSettings;
    qt5ctSettings = qtSettings;
  };
  # Doesn't work
  # xdg.configFile."Thunar/thunarrc".text = ''
  #   [Configuration]
  #   LastView=ThunarDetailsView
  #   LastSidePane=ThunarTreeModel
  # '';

  xfconf.settings.thunar."default-view" = "ThunarDetailsView";
}
