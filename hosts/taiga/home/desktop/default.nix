{
  pkgs,
  ...
}:

{
  modules = {
    xdgPortal.enable = true;
  };

  home.packages = with pkgs; [
    grim # Screenshot utility
    slurp # Select a region for a screenshot
    satty # Screenshot editor
  ];

  services = {
    wlsunset = {
      enable = true;
      latitude = "-20";
      longitude = "-45";
      gamma = 1.0;
      temperature = {
        day = 5500;
        night = 4000;
      };
    };
  };
}
