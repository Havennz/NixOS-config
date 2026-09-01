{
  ...
}:

{
  #hardware.opentabletdriver.enable = true;

  #programs.localsend.enable = true;
  # services.input-remapper.enable = true;

  #services.printing = {
  #  enable = true;
  #  webInterface = false;
  #};

  modules = {
    programs = {
      apps = {
        nautilus = {
          enable = true;
          extraExtensions = true;
          settings = {
            showHiddenFiles = true;
            dconf = {
              preferences = {
                show-delete-permanently = true;
                show-create-link = true;
              };
              icon-view.default-zoom-level = "medium";
            };
          };
        };
        gpu-screen-recorder = {
          enable = true;
          ui.enable = true;
        };
        qbittorrent.enable = true;
      };

      gaming = {
        enable = true;
        game-optimize.settings = {
          CpuThreads = 12;
          # VulkanDevice = "1002:67df";
          DXVKDeviceName = "AMD Radeon";
        };

        gamescope.session = {
          enable = true;
          monitor = 0;
          settings = {
            # VulkanAdapter = "1002:67df";
            SteamDeckHud = false;
            MangoApp = true;
          };
        };
      };
    };
  };
}
