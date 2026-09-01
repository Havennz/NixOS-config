{
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  modules = {

    hardware = {
      core.enable = true;
      # archOptimizations.variant = "x86_64-v3";
      displays = {
        enable = true;
        monitors = [
          {
            adapter = "DP-3";
            resolution = {
              width = 1920;
              height = 1080;
            };
            refreshRate = 60;
            variableRefreshRate = false;
            scale = 1;
            position = {
              x = 0;
              y = 0;
            };
            colorManagement = {
              enable = false;
              hdr = false;
              bitDepth10 = false;
            };
          }
          {
            adapter = "HDMI-A-1";
            resolution = {
              width = 1440;
              height = 900;
            };
            refreshRate = 75;
            variableRefreshRate = false;
            scale = 1;
            position = {
              x = -1440;
              y = 0;
            };
            colorManagement = {
              enable = false;
              hdr = false;
              bitDepth10 = false;
            };
          }
        ];
      };

      bluetooth.enable = false;
      cpu.intel.enable = true;

      gpu = {
        graphics = {
          enable = true;
        };
        vaapi.enable = true;
        nvtop.enable = true;
        amd = {
          enable = true;
          initrd = true;
        };
      };

      disk = {
        enable = true;
        device = "/dev/disk/by-id/ata-MCR-RPRS-480_QCX202408040183";
        swap.file.size = "12G";
        mainPartition.size = "300G";
        ephemeral.enable = true;
      };
    };
  };
}
