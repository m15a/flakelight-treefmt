{
  lib,
  config,
  inputs,
  ...
}:

let
  inherit (builtins) attrValues;
  inherit (lib)
    mkIf
    mkMerge
    mkOption
    optional
    optionals
    ;
  inherit (lib.types)
    attrs
    bool
    oneOf
    path
    ;
  inherit (inputs.treefmt-nix.lib) evalModule;

  treefmtEval = pkgs: evalModule pkgs config.treefmtConfig;
  treefmtWrapper = pkgs: (treefmtEval pkgs).config.build.wrapper;
  treefmtPrograms = pkgs: attrValues (treefmtEval pkgs).config.build.programs;
in

{
  options = {
    treefmtConfig = mkOption {
      description = "Treefmt configuration as an attribute set or file path.";
      type = oneOf [
        attrs
        path
      ];
      default = { };
    };

    treefmtWrapperInDevShell = mkOption {
      description = "Whether to add treefmt wrapper to `devShell.packages`.";
      type = bool;
      default = true;
    };

    treefmtProgramsInDevShell = mkOption {
      description = "Whether to add treefmt programs to `devShell.packages`.";
      type = bool;
      default = true;
    };
  };

  config = mkMerge [
    (mkIf (config.treefmtWrapperInDevShell || config.treefmtProgramsInDevShell) {
      devShell.packages =
        pkgs:
        optional config.treefmtWrapperInDevShell (treefmtWrapper pkgs)
        ++ optionals config.treefmtProgramsInDevShell (treefmtPrograms pkgs);
    })
    {
      formatter = treefmtWrapper;
    }
  ];
}
