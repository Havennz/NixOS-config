{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:

let
  tuningCfg = osConfig.modules.system.tuning;
  localeCfg = osConfig.modules.system.locale;
  hardwareCfg = osConfig.modules.hardware;
  gsrCfg = osConfig.modules.programs.apps.gpu-screen-recorder;
  wivrnCfg = osConfig.modules.services.vr.wivrn;
  desktopOptimizeCfg = osConfig.modules.programs.gaming.desktop-optimize;
  noctaliaCfg = config.programs.noctalia-shell;

  mkEnableServiceCustomButton =
    {
      name,
      service,
      icon,
      enabledIcon ? null,
      notifyIcon ? null,
    }:
    {
      id = "CustomButton";
      generalTooltipText = name;
      icon = icon;
      onClicked = "${pkgs.writeShellScript "toggle-${service}-service" ''
        isActive=$(systemctl --user is-active ${service}.service)
        toggleState="ERROR"
        if [ "$isActive" = "active" ]; then
          systemctl --user stop ${service}.service
          toggleState="disabled"
        else
          systemctl --user start ${service}.service
          toggleState="enabled"
        fi

        ${
          if notifyIcon != null then
            ''notify-send --icon "${notifyIcon}" --app-name "${name}" "${name} is now $toggleState."''
          else
            ""
        }
      ''}";
      onMiddleClicked = "";
      onRightClicked = "";
      enableOnStateLogic = enabledIcon != null;
      stateChecksJson =
        if enabledIcon != null then
          ''[{"command":"systemctl --user is-active ${service}.service","icon":"${enabledIcon}"}]''
        else
          "";
    };

  mkNoctaliaPluginList =
    pluginList:
    lib.listToAttrs (
      lib.map (name: {
        inherit name;
        value = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      }) pluginList
    );

  # Granting your user access to the input group weakens Wayland's input confidentiality model.
  # Once your user can read raw input devices directly,
  # any process running as that user may also be able to observe keyboard input outside the compositor's usual security boundaries.
  # Use this plugin only if you understand and accept that tradeoff.
  # If you are not comfortable granting input access,
  # do not enable this plugin until a compositor-native or otherwise safer input API exists.
  # REMEMBER TO ADD YOUR USER TO THE "input" GROUP IN YOUR CONFIGURATION
  # EX: users.users.<user>.extraGroups = [ "input" ];
  inputPlugins = false;
in
{
  config = lib.mkIf (config.programs ? noctalia-shell && config.programs.noctalia-shell.enable) {
    modules.desktop.hyprland.extraLuaFiles."nix.noctalia.keybinds" = ''
      hl.bind("SUPER + CTRL + minus", hl.dsp.exec_cmd("noctalia-shell ipc call bar toggle"))
      hl.bind("SUPER + I", hl.dsp.exec_cmd("noctalia-shell ipc call notifications toggleHistory"))
      hl.bind("SUPER + CTRL + W", hl.dsp.exec_cmd("noctalia-shell ipc call launcher toggle"))
      hl.bind("SUPER + CTRL + Q", hl.dsp.exec_cmd("noctalia-shell ipc call sessionMenu toggle"))
      hl.bind("SUPER + Q", hl.dsp.exec_cmd("noctalia-shell ipc call lockScreen lock"))
      hl.bind("SUPER + CTRL + X", hl.dsp.exec_cmd("noctalia-shell ipc call wallpaper toggle"))
      hl.bind("SUPER + X", hl.dsp.exec_cmd("noctalia-shell ipc call wallpaper random"))
      hl.bind("SUPER + CTRL + N", hl.dsp.exec_cmd("noctalia-shell ipc call plugin:clipper toggle"))
    '';

    # This module uses a noctalia plugin as a polkit agent.
    services.hyprpolkitagent.enable =  false;

    # Plugin dependencies
    home.packages =
      with pkgs;
      #https://noctalia.dev/plugins/screen-toolkit
      [
        grim
        slurp
        hyprpicker
        wl-clipboard
        tesseract
        imagemagick
        zbar
        curl
        translate-shell
        wl-screenrec
        ffmpeg-full
        gifski
        jq
        python3
        python3Packages.pygobject3
        xdg-desktop-portal
      ]
      # https://noctalia.dev/plugins/currency-exchange
      ++ [
        curl
        wl-clipboard
      ]
      ++ lib.optionals inputPlugins [
        evtest
      ];

    programs.noctalia-shell = {
      # Allow noctalia to manage its own colors in a mutable way
      colors = lib.mkForce { };

      settings =  {
        wallpaper.directory = "${config.home.homeDirectory}/Imagens/Wallpapers";
        location.name = "Piracicaba, SP";
        bar = {
          widgets = {
            left = [
              {
                id = "Clock";
                usePrimaryColor = false;
              }
              {
                id = "plugin:world-clock";
              }
              {
                id = "SystemMonitor";
                compactMode = false;
              }
              {
                id = "ActiveWindow";
              }
              {
                id = "MediaMini";
              }
            ]
            ++ lib.optionals config.modules.desktop.hyprland.enable [
              {
                id = "CustomButton";
                icon = "target-arrow";
                leftClickExec = "${lib.getExe pkgs.hyprctl-kill-sound}";
              }
            ];
            center = [
              {
                id = "Workspace";
              }
              {
                id = "plugin:screen-toolkit";
              }
            ];
            right = [
              {
                id = "plugin:clipper";
              }
              {
                id = "plugin:todo";
              }
              {
                id = "plugin:sticky-notes";
              }
              {
                id = "Tray";
                drawerEnabled = false;
              }
              {
                id = "plugin:privacy-indicator";
              }
              {
                id = "plugin:network-indicator";
              }
            ]
            ++ lib.optionals gsrCfg.enable [
              {
                id = "plugin:screen-recorder";
              }
            ]
            ++ lib.optionals tuningCfg.enable (
              lib.optionals tuningCfg.tuned.enable [
                {
                  id = "PowerProfile";
                }
              ]
              ++ lib.optionals (hardwareCfg.systemType == "mobile" && tuningCfg.upower.enable) [
                {
                  id = "Battery";
                  displayMode = "alwaysShow";
                  showNoctaliaPerformance = true;
                  showPowerProfiles = true;
                }
              ]
            )
            ++ lib.optionals osConfig.modules.system.sound.enable [
              {
                id = "Volume";
                displayMode = "alwaysShow";
              }
            ]
            ++ lib.optionals (hardwareCfg.systemType == "mobile") [
              {
                id = "Brightness";
                displayMode = "alwaysShow";
              }
            ]
            ++ [
              {
                id = "NotificationHistory";
              }
            ]
            ++ lib.optionals (localeCfg.enable && (lib.hasInfix localeCfg.keyboard.layout ",")) [
              {
                id = "KeyboardLayout";
                displayMode = "forceOpen";
                showIcon = true;
              }
            ]
            ++ [
              {
                id = "ControlCenter";
              }
            ];
          };
        };

        controlCenter = {
          cards = [
            {
              enabled = true;
              id = "profile-card";
            }
            {
              enabled = true;
              id = "shortcuts-card";
            }
            {
              enabled = true;
              id = "audio-card";
            }
            {
              enabled = hardwareCfg.systemType == "mobile";
              id = "brightness-card";
            }
            {
              enabled = false;
              id = "weather-card";
            }
            {
              enabled = true;
              id = "media-sysmon-card";
            }
          ];
          shortcuts = {
            left = [
              { id = "Network"; }
            ]
            ++ lib.optionals hardwareCfg.bluetooth.enable [
              { id = "Bluetooth"; }
            ]
            ++ [
              { id = "WallpaperSelector"; }
            ]
            ++ lib.optionals gsrCfg.ui.enable [
              (mkEnableServiceCustomButton {
                name = "GPU Screen Recorder UI";
                service = "gpu-screen-recorder-ui";
                icon = "camera";
                enabledIcon = "camera-check";
                notifyIcon = "${gsrCfg.ui.package}/share/gsr-ui/images/gpu_screen_recorder_logo.png";
              })
            ]
            ++ lib.optionals wivrnCfg.enable [
              (mkEnableServiceCustomButton {
                name = "WiVRn";
                service = "wivrn";
                icon = "badge-vr";
                enabledIcon = "badge-vr-filled";
                notifyIcon = "${osConfig.services.wivrn.package}/share/icons/hicolor/scalable/apps/io.github.wivrn.wivrn.svg";
              })
            ];

            right = [
              { id = "Notifications"; }
              { id = "KeepAwake"; }
              { id = "NightLight"; }
            ]
            ++ lib.optionals (tuningCfg.enable && tuningCfg.tuned.enable) [
              { id = "PowerProfile"; }
            ]
            ++ lib.optionals (desktopOptimizeCfg.enable) [
              {
                id = "CustomButton";
                generalTooltipText = "Toggle Desktop Optimize";
                icon = "rocket";
                onClicked = "${lib.getExe desktopOptimizeCfg.packageToggle}";
                onMiddleClicked = "";
                onRightClicked = "";
                enableOnStateLogic = true;
                stateChecksJson = ''[{"command":"${pkgs.writeShellScript "check-desktop-optimize-state" ''
                  if [ -f /tmp/optimize-desktop/state-$(whoami) ]; then
                    OPTIMIZE_DESKTOP_STATE=$(cat /tmp/optimize-desktop/state-$(whoami))
                    if [ "$OPTIMIZE_DESKTOP_STATE" = 1 ]; then
                      echo "enabled"
                      exit 0
                    fi
                  fi
                  echo "disabled"
                  exit 1
                ''}","icon":"rocket-off"}]'';
              }
            ];
          };
        };

        nightLight = {
          enabled = true;
          forced = false;
          autoSchedule = true;
          dayTemp = "5500";
          nightTemp = "4000";
          manualSunrise = "08:30";
          manualSunset = "17:30";
        };
      };

      plugins = {
        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
        ];
        states = mkNoctaliaPluginList (
          [
            "network-indicator"
            "privacy-indicator"
            "todo"
            "world-clock"
            "translator"
            "clipper"
            "sticky-notes"
            "currency-exchange"
            "polkit-agent"
            "parallax-wallpaper"
            "screen-toolkit"
            "unicode-picker"
          ]
          ++ lib.optionals gsrCfg.enable [
            "screen-recorder"
          ]
          ++ lib.optionals inputPlugins [
            "show-keys"
          ]
        );
        version = 2;
      };

      pluginSettings =  (
        {
          privacy-indicator = {
            hideInactive = false;
            iconSpacing = 2;
            removeMargins = false;
          };
          todo = {
            showBackground = true;
            showCompleted = true;
          };
          world-clock = {
            rotationInterval = 5000;
            showDate = true;
            timeFormat = "HH:mm";
            timezones = [
              {
                enabled = true;
                name = "New York";
                timezone = "America/New_York";
              }
              {
                enabled = true;
                name = "London  ";
                timezone = "Europe/London";
              }
              {
                enabled = true;
                name = "Tokyo   ";
                timezone = "Asia/Tokyo";
              }
            ];
          };
          currency-exchange = {
            sourceCurrency = "BRL";
            targetCurrency = "USD";
            widgetDisplayMode = "icon";
            refreshInterval = 60;
          };
          parallax-wallpaper = {
            zoomAmount = 1.2;
            parallaxDirection = "horizontal";
            hParallaxAmount = 20;
            hParallaxDuration = 300;
            vParallaxAmount = 11;
            vParallaxDuration = 300;
            invertDirection = false;
            autoZoom = true;
            parallaxEasing = "OutCubic";
          };
          screen-toolkit = {
            screenshotPath = "${config.home.homeDirectory}/Imagens/Screenshots/ScreenToolkit";
            videoPath = "${config.home.homeDirectory}/Vídeos/ScreenToolkit";
          };
        }
        // lib.optionalAttrs gsrCfg.enable {
          screen-recorder = {
            directory = "${config.home.homeDirectory}/Vídeos";
            filenamePattern = "recording_yyyyMMdd_HHmmss";
            frameRate = "60";
            audioCodec = "aac";
            videoCodec = "h264";
            quality = "very_high";
            colorRange = "limited";
            showCursor = true;
            copyToClipboard = false;
            audioSource = "both";
            videoSource = "portal";
          };
        }
      );
    };

    # Temporary fix:
    # some plugins require a mutable settings.json to function properly,
    # so we remove the upstream way of using xdg.configFile and use mutable config files
    xdg.configFile = lib.mapAttrs' (
      name: value:
      lib.nameValuePair "noctalia/plugins/${name}/settings.json" {
        enable = lib.mkForce false;
      }
    ) noctaliaCfg.pluginSettings;
    modules.mutable.file = lib.mapAttrs' (
      name: value:
      lib.nameValuePair ".config/noctalia/plugins/${name}/settings.json" {
        content = value;
        merge = {
          enable = true;
          method = "json";
        };
      }
    ) noctaliaCfg.pluginSettings;
  };
}
