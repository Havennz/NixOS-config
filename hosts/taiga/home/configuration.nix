{
  extralib,
  ...
}:
{
  imports = extralib.usePresets [
    "oobe/home"
  ];

  presets.mansaos-oobe = {
    profileImage = ./profile.png;
    excludePackages = [
      "shadower"
    ];
  };
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
  };
}
