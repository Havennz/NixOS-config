{
  config,
  extralib,
  hypr-dynamic-cursors,
  hypr-darkwindow,
  hyprland-contrib,
  ...
}:

{
  imports = extralib.umport {
    path = ./.;
    exclude = [
      ./configuration.nix
      ./home
    ];
  };

  modules = {
    system = {
      settings = {
        users = {
          root.initialPassword = "laele2003";

          alec = {
            description = "Alec";
            initialPassword = "laele2003";
            shell = config.programs.fish.package;
            hm.config = {
              imports = extralib.umport {
                path = ./home;
              };
            };
          };
        };

        stateVersion = "26.05";
      };
      homeManager = {
        enable = true;
        specialArgs = {
          inherit hypr-dynamic-cursors hypr-darkwindow hyprland-contrib;
        };
      };
    };
    programs.displayManager.sddm.enable = true;
  };
}
