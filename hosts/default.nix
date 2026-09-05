{
  inputs,
  ...
}:

let
  mkNixosSystem = inputs.mansaos.lib.mkNixosSystemDefaults {
    defaultLocation = ./.;
    defaultPresetsSources = {
      oobe = inputs.mansaos-oobe.presets;
    };
  };
in
{
  flake.nixosConfigurations = {
    taiga = mkNixosSystem {
      hostName = "taiga";
      presets = [
        "oobe/system"
        "mansaos/setup/workstation"
      ];
      specialArgs = {
        inputs = {
          inherit (inputs)
            hypr-dynamic-cursors
            hypr-darkwindow
            stylix
            ;
        };
      };
    };
  };
}
