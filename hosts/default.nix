{
  inputs,
  ...
}:

let
  mkNixosSystem = inputs.mansaos.lib.mkNixosSystemDefaults {
    defaultLocation = ./.;
  };
in
{
  flake.nixosConfigurations = {
    taiga = mkNixosSystem {
      hostName = "taiga";
      presets = [
        "mansaos/theme/system/stylix-basic"
        "mansaos/theme/system/noctalia-shell"
        "mansaos/setup/workstation"
      ];
      specialArgs = {
        inherit (inputs) hypr-dynamic-cursors hypr-darkwindow hyprland-contrib;
      };
    };
  };
}
