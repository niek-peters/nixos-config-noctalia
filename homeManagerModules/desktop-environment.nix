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
  mkFocusWorkspace = i: mkExec "focus({ workspace = ${i} })";
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.kitty.enable = true;
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
          rounding = 20;
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
        (mkBindExec "SUPER + T" "kitty")
        (mkBindExec "SUPER + W" "helium")
        (mkBindExec "SUPER + E" "thunar")
        (mkBindExec "SUPER + C" "code")

        # Recommended Noctalia base keybinds
        (mkBindIPC "SUPER + Space" "panel-toggle launcher")
        (mkBindIPC "SUPER + S" "panel-toggle control-center")
        (mkBindIPC "SUPER + comma" "settings-toggle")
        (mkBindIPC "ALT + Tab" "window-switcher")

        # Workspace switching
        (mkFocusWorkspace "SUPER + 1" 1)
        (mkFocusWorkspace "SUPER + 2" 2)
        (mkFocusWorkspace "SUPER + 3" 3)
        (mkFocusWorkspace "SUPER + 4" 4)
        (mkFocusWorkspace "SUPER + 5" 5)
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
    #extraConfig = ''
    #  hl.exec_cmd("noctalia")
    #'';
  };

  # Hint Electron apps to use Wayland
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.noctalia = {
    enable = true;
    settings = {
      theme = {
        mode = "dark";
        source = "wallpaper";
      };
      wallpaper = {
        enabled = true;
        default.path = "~/Pictures/Wallpapers/wallhaven-ymz61d.jpg";
      };
      brightness.monitor.eDP-1 = {
        backend = "backlight";
        backlight_device = "amdgpu_bl1";
      };
    };
  };
}
