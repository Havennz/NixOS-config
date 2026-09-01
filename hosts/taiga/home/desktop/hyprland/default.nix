{
  osConfig,
  lib,
  pkgs,
  ...
}:

let
  displaysCfg = osConfig.modules.hardware.displays;
in
{
  modules.desktop.hyprland = {
    enable = true;

    extraVariables = {
      autoWorkspaceRules = {
        enable = displaysCfg.enable;
        countPerMonitor = 9;
        extraRules = {
          #"3" = {
          #  layout = "scrolling";
          #};
          #"4" = {
          #  layout = "master";
          #};
        };
      };
      displays = displaysCfg.monitors;
      executable = {
        satty = lib.getExe pkgs.satty;
        jq = lib.getExe pkgs.jq;
      };
    };
    extraLuaFiles = {
      "nix.rules" = ./rules.lua;
      "nix.keybinds" = ./keybinds.lua;
    };

    environmentVariables = {
      EDITOR = "nvim";
    };

    settings.config = {
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 0;
      };

      decoration = {
        rounding = 25;
        inactive_opacity = 1;
        active_opacity = 1;
        fullscreen_opacity = 1;
        #dim_inactive = true;
        #dim_strength = 0.5;

        blur = {
          enabled = false;
          size = 1;
          passes = 2;
        };

        shadow = {
          enabled = true;
          range = 10;
          render_power = 3;
          #sharp = true; # if enabled, will make the shadows sharp, akin to an infinite render power
          color = "rgba(00000010)";
          color_inactive = "rgba(00000099)";
        };
      };

      input = {
        # If disabled, mouse focus won’t switch to the hovered window
        # unless the mouse crosses a window boundary when follow_mouse=1.
        mouse_refocus = false;
      };

      misc.disable_hyprland_logo = true;

      cursor = {
        zoom_factor = 1.0;
        zoom_rigid = false;
        no_hardware_cursors = 1;
      };

      debug.disable_logs = true;
    };

    hyprcursor = {
      enable = true;
      theme = "Posys-Cursor-Scalable-Black";
      package = pkgs.callPackage (
        {
          lib,
          stdenv,
          fetchzip,
          color ? "black",
        }:

        let
          themeName = "Posys-Cursor-Scalable-${lib.toSentenceCase color}";
        in
        stdenv.mkDerivation (finalAttrs: {
          pname = "posy-cursors-hyprcursor";
          version = "1.3";

          src = fetchzip {
            url = "https://github.com/Morxemplum/posys-cursor-scalable/releases/download/v1.3/hyprcursor_${color}_v${finalAttrs.version}.tar.gz";
            sha256 = "sha256-bz9vmhEwiPCk8A5gnqR6m3jFyb9w/xE5FrdrqTQZNgk=";
          };

          installPhase = ''
            runHook preInstall

            mkdir -p $out/share/icons/${themeName}
            cp -R . $out/share/icons/${themeName}/

            runHook postInstall
          '';

          meta = {
            description = "Posy's Improved Cursors for Hyprcursor";
            homepage = "https://github.com/Morxemplum/posys-cursor-scalable";
            platforms = lib.platforms.unix;
            license = lib.licenses.cc-by-nc-40;
          };
        })
      ) { };
    };
  };
}
