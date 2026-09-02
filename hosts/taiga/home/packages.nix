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
      "vscode"
      "mpv"
      "floorp"
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
    bash.enable = true;

    git = {
      enable = true;
      settings.user = {
        name = "Alec Alexandre";
        email = "alecalexandre80@gmail.com";
      };
    };

    vscode = {
      enable = true;
      profiles.default.userSettings = {
        "files.autoSave" = "afterDelay";
        "workbench.editor.enablePreview" = true;
        "explorer.confirmDelete" = false;
      };
    };

    eza = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };

    fd = {
      enable = true;
    };

    bat = {
      enable = true;
      config = {
        pager = "less -FR";
      };
      extraPackages = with pkgs.bat-extras; [
        batman # Man pages with syntax highlighting
        prettybat # bat with formatting
      ];
    };
  };

  home.packages = with pkgs; [
    kdePackages.kdenlive
    gimp3-with-plugins
    bazaar
    footage
    spotify
    codex
  ];

  modules = {
    impermanence.directories = [
      ".cache/tealdeer"
      ".cache/spotify"
      ".config/spotify"
    ];

    apps = {
      fish.enable = true;
      lutris.enable = true;
      atuin.enable = true;
      alacritty.enable = true;
      fastfetch.enable = true;
      starship.enable = true;
    };

    flatpak = {
      packages = [
        "org.qbittorrent.qBittorrent"
        "org.nickvision.tubeconverter"
        "org.vinegarhq.Sober"
        "com.github.taiko2k.avvie" # Crop and downsize images easily
        "org.gnome.gitlab.YaLTeR.VideoTrimmer" # Cut videos easily
        "page.kramo.Sly" # A friendly image editor that requires no internet connection or preexisting expertise. Just open a photo and have at it.
        # Core
        "com.github.tchx84.Flatseal" # Manage permissions of flatpak apps
        "io.github.flattool.Warehouse" # Manages installed Flatpaks, their user data, and Flatpak remotes.
      ];
    };
  };
}
