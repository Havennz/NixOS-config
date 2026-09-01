{
  extralib,
  ...
}:

{
  imports = extralib.usePresets [
    "mansaos/theme/home/noctalia-shell"
    "mansaos/home/essential"
  ];

  home.file.".face".source = ./profile.png;

  modules = {
    impermanence = {
      enable = true;

      directories = [
        # common user directories
        "Downloads"
        "Documentos"
        "Imagens"
        "Vídeos"
        "Músicas"
        # other
        "Games"
        # nixos flake
        "NixOS"
      ];
    };

    ssh = {
      enable = true;
    };

    defaultApps = {
      browser = [ "floorp.desktop" ];
      audio = [ "mpv.desktop" ];
      video = [ "mpv.desktop" ];
    };
  };
}
