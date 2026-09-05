{
  outputs =
    inputs:

    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./hosts
      ];

      systems = [
        "x86_64-linux"
      ];
    };

  inputs = {
    flake-parts.follows = "mansaos/flake-parts";
    nixpkgs.follows = "mansaos/nixpkgs";
    mansaos = {
      url = "git+https://git.seikm.com/Seikm/MansaOS.git";
    };
    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors/e9056fd4f2b229d9924aa853c4763d6bc314bb34";
      inputs.hyprland.follows = "mansaos/hyprland";
      inputs.nixpkgs.follows = "mansaos/hyprland/nixpkgs";
    };
    hypr-darkwindow = {
      url = "github:micha4w/Hypr-DarkWindow/87155d40e2ce52df6b22801ea8dd87bb4ed28d6d";
      inputs.hyprland.follows = "mansaos/hyprland";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    mansaos-oobe = {
      url = "git+https://git.seikm.com/Seikm/MansaOS-OOBE.git";
      inputs.flake-parts.follows = "flake-parts";
    };
  };
}

# Rebuild target
# nixos-rebuild switch --flake <flakeLocation>#<configuration> --target-host "root@<ip>"
