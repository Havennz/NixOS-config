{
  extralib,
  pkgs,
  ...
}:

{
  imports = extralib.usePresets (
    map (app: "mansaos/app/${app}") [
      "discord"
      "easyeffects"
      "obs-studio"
    ]
  );

  presets.app = {
    floorp = {
      # userChrome.sidebar = {
      #   hideDelay = "0ms";
      # };
      profiles = {
        home = {
          id = 0;
          search.default = "google";
        };
        roguezin = {
          id = 1;
        };
      };
    };
    discord-canary = {
      enable = true;
      extraDiscordPackageConfig.vulkan = false;
    };
  };

  programs = {
    obsidian.enable = true;

    git = {
      settings.user = {
        name = "Alec Alexandre";
        email = "alecalexandre80@gmail.com";
      };
    };

    vscode = {
      profiles.default.userSettings = {
        "files.autoSave" = "afterDelay";
        "workbench.editor.enablePreview" = true;
        "explorer.confirmDelete" = false;
        "editor.formatOnSave" = true;
      };
    };
  };

  home.packages = with pkgs; [
    kdePackages.kdenlive
    gimp3-with-plugins
    footage
    spotify
    codex
  ];

  modules = {
    impermanence.directories = [
      ".cache/spotify"
      ".config/spotify"
    ];

    apps = {
      lutris.enable = true;
    };

    flatpak = {
      packages = [
        "org.qbittorrent.qBittorrent"
        "org.nickvision.tubeconverter"
        "org.vinegarhq.Sober"
        "com.github.taiko2k.avvie" # Crop and downsize images easily
        "org.gnome.gitlab.YaLTeR.VideoTrimmer" # Cut videos easily
        "page.kramo.Sly" # A friendly image editor that requires no internet connection or preexisting expertise. Just open a photo and have at it.
      ];
    };
  };
}
