{
  lib,
  config,
  inputs,
  ...
}:

let
  inherit (builtins) attrValues;
  inherit (lib)
    mkForce
    mkIf
    mkMerge
    mkOption
    ;
  inherit (lib.types)
    attrs
    bool
    oneOf
    path
    ;
  inherit (inputs.treefmt-nix.lib) evalModule;

  build = pkgs: (evalModule pkgs config.treefmtConfig).config.build;
  wrapper = pkgs: (build pkgs).wrapper;
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
    (mkIf config.treefmtWrapperInDevShell {
      devShell.packages = pkgs: [ (wrapper pkgs) ];
    })
    (mkIf config.treefmtProgramsInDevShell {
      devShell.packages = pkgs: attrValues (build pkgs).programs;
    })
    {
      formatter = mkForce wrapper;
      checks.formatting = mkForce (pkgs: (build pkgs).check inputs.self);
    }
  ];
}
