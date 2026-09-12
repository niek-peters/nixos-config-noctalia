{ inputs, lib, ... }:
let
  mkBind = key: cmd: {
    _args = [
      key
      (lib.generators.mkLuaInline "hl.dsp.${cmd}")
    ];
  };
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
        (mkBind "SUPER + T" ''exec_cmd("kitty")'')
        (mkBind "SUPER + W" ''exec_cmd("helium")'')
        (mkBind "SUPER + E" ''exec_cmd("thunar")'')
        (mkBind "SUPER + C" ''exec_cmd("code")'')
        (mkBind "SUPER + Space" ''exec_cmd("noctalia-launcher")'')
        #(mkBind "SUPER + T" "kitty")
        #(mkBind "SUPER + Space" "noctalia-launcher")
      ];
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
    };
  };
}
