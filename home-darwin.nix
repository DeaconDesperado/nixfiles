{ lib, ... }:

{
  home.file."sketchybar" = {
    source = lib.cleanSource ./development/config/sketchybar;
    target = ".config/sketchybar";
    recursive = true;
  };
}
