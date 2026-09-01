# MansaOS

Example installation steps:

_This assumes you are inside a live NixOS iso, active network connection, and ssh keys configured to access the git repository._

- Format driver
  `nix --experimental-features "nix-command flakes" run git+https://git.seikm.com/Seikm/MansaOS#mansao-installer -- format --device "/dev/sda" --swapFileSize "12G" --ephemeralEnable true --ephemeralType "btrfs" --mainPartitionSize "300G"`

- Get hardware configuration (optional)
  `sudo nixos-generate-config --no-filesystems --root /mnt`

- Install MansaOS
  `nix --experimental-features "nix-command flakes" run git+https://git.seikm.com/Seikm/MansaOS#mansao-installer -- install --root /mnt --flake .#taiga`
