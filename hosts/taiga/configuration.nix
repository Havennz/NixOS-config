{
  config,
  extralib,
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
          root.initialPassword = "3744";

          alec = {
            description = "Alec";
            initialPassword = "3744";
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
      homeManager.enable = true;
    };
  };
}
