{ pkgs }: 
let
  writeConfigFiles = dir:
    builtins.map (file:
      if pkgs.lib.strings.hasSuffix ".nix" file then
        pkgs.writeTextFile {
          name = pkgs.lib.strings.removeSuffix ".nix" file;
          text = import ./config/${dir}/${file} { inherit pkgs; };
        } 
      else
       pkgs.writeTextFile {
         name = file;
         text = builtins.readFile ./config/${dir}/${file};
      } 
    )
    (builtins.attrNames (builtins.readDir ./config/${dir}));

  sourceConfigFiles = files:
    builtins.concatStringsSep "\n" (builtins.map (file:
      (if pkgs.lib.strings.hasSuffix "lua" file then "luafile" else "source")
      + " ${file}") files);

  luaConfigFiles = writeConfigFiles "lua";
  vimConfigFiles = writeConfigFiles "vim";
in builtins.concatStringsSep "\n"
  (builtins.map (configs: sourceConfigFiles configs) [ luaConfigFiles vimConfigFiles ])
