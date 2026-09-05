{
  config,
  lib,
  ...
}:

{
  modules.xdgPortal = {
    settings = {
      accent_color = "#1c81da";
    };
  };

  wayland.windowManager.hyprland.settings.config.decoration.shadow = lib.mkIf config.stylix.enable {
    color = lib.mkOverride 40 "rgba(00000010)";
    color_inactive = lib.mkOverride 40 "rgba(00000099)";
  };
}
