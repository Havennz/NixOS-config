{
  ...
}:

{
  modules.system = {
    kernel = {
      kernel = "cachyos-bore-lto";
      scx.scheduler = "scx_lavd";
    };

    boot = {
      loader = {
        bootloader = "limine";
        limine = {
          extraEntries = ''
            /Windows
              protocol: efi
              path: boot():/efi/Microsoft/Boot/bootmgfw.efi
          '';
        };
      };
      plymouth.enable = true;
    };

    nix = {
      build.limit-resources.enable = true;
      editor = true;
      flake = "/home/alec/NixOS/flake-nixConfig";
    };

    # sound.pipewire.latency = "high";
    tuning.zram.algorithm = "lz4";
    impermanence.enable = true;
  };
}
