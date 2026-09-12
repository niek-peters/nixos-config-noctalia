{ inputs, lib, ... }:
let
  mkBind = key: cmd: { 
    _args = [
      key
      (lib.generators.mkLuaInline "hl.dsp.${cmd}")
    ];
  }
  mkExec = cmd: lib.generators.mkLuaInline ''
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
        (mkBind "SUPER + T" ''exec_cmd("kitty")'')
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
        default.path = "~/Pictures/Wallpapers/wallhaven-pkw6y3.jpg";
      };
    };
  };
}
