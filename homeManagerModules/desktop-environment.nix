{ inputs, lib, ... }:
let
  mkBind = key: cmd: {
    _args = [
      key
      (lib.generators.mkLuaInline "hl.dsp.${cmd}")
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
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  #programs.kitty.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;

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
        };

        misc.force_default_wallpaper = 0;
      };

      monitor = {
        output = "eDP-1";
        mode = "1920x1080@60.01Hz";
        position = "0x0";
        scale = 1.25;
      };

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
        (mkBind "SUPER + Q" "window.close()")
        (mkBindExec "SUPER + T" "foot")
        (mkBindExec "SUPER + W" "helium")
        (mkBindExec "SUPER + E" "thunar")
        (mkBindExec "SUPER + C" "code")

        # Recommended Noctalia base keybinds
        (mkBindIPC "SUPER + Space" "panel-toggle launcher")
        (mkBindIPC "SUPER + S" "panel-toggle control-center")
        (mkBindIPC "SUPER + comma" "settings-toggle")
        (mkBindIPC "ALT + Tab" "window-switcher")

        # Workspace switching
        (mkFocusWorkspace 1)
        (mkFocusWorkspace 2)
        (mkFocusWorkspace 3)
        (mkFocusWorkspace 4)
        (mkFocusWorkspace 5)
        #(mkBind "SUPER + T" "kitty")
        #(mkBind "SUPER + Space" "noctalia-launcher")
      ];

      workspace_rule = [
        (mkWorkspace 1)
        (mkWorkspace 2)
        (mkWorkspace 3)
        (mkWorkspace 4)
        (mkWorkspace 5)
      ];

      window_rule = {
        match.class = "dev.noctalia.Noctalia";
        float = true;
        size = [
          1080
          920
        ];
      };

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
}
