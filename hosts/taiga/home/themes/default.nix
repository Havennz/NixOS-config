{
  config,
  lib,
  extralib,
  ...
}:

{
  imports = extralib.usePresets [
    "mansaos/theme/home/basic"
  ];

  modules.xdgPortal = {
    settings = {
      accent_color = "#be143f";
    };
    fileChooser.open_file = "Gnome"; # open_file already set all others
  };

  stylix.targets = {
    vscode.enable = false;
  };

  wayland.windowManager.hyprland.settings.config.decoration.shadow = lib.mkIf config.stylix.enable {
    color = lib.mkForce "rgba(00000010)";
    color_inactive = lib.mkForce "rgba(00000099)";
  };
}
