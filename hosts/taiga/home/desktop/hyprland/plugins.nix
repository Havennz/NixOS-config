{
  pkgs,
  inputs,
  ...
}:

# https://wiki.hypr.land/Plugins/
{
  home.packages = [
    pkgs.hyprpwcenter
    # Screenshot tools
    inputs.hyprland-contrib.packages.${pkgs.stdenv.hostPlatform.system}.grimblast # Area picker and screenshot tool
  ];

  modules.desktop.hyprland = {
    plugins = [
      inputs.hypr-dynamic-cursors.packages.${pkgs.stdenv.hostPlatform.system}.hypr-dynamic-cursors
      inputs.hypr-darkwindow.packages.${pkgs.stdenv.hostPlatform.system}.Hypr-DarkWindow
    ];

    settings.config.plugin.dynamic_cursors =  {
      enabled = true;
      # sets the cursor behaviour, supports these values:
      # tilt    - tilt the cursor based on x-velocity
      # rotate  - rotate the cursor based on movement direction
      # stretch - stretch the cursor shape based on direction and velocity
      # none    - do not change the cursor's behaviour
      mode = "tilt";
      # for mode = "rotate"
      rotate = {
        # length in px of the simulated stick used to rotate the cursor
        # most realistic if this is your actual cursor size
        length = 10;
        # clockwise offset applied to the angle in degrees
        # this will apply to ALL shapes
        offset = 0;
      };
      # configure shake to find
      # magnifies the cursor if its being shaken
      shake = {
        enabled = true;
        # controls how soon a shake is detected
        # lower values mean sooner
        threshold = 7.0;
        # magnification level immediately after shake start
        base = 4.0;
        # magnification increase per second when continuing to shake
        speed = 4.0;
        # how much the speed is influenced by the current shake intensity
        influence = 1.0;
        # show cursor behaviour `tilt`, `rotate`, etc. while shaking
        effects = true;
      };
    };
  };
}
