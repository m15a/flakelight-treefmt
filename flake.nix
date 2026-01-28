{
  inputs = {
    flakelight.url = "github:nix-community/flakelight";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "flakelight/nixpkgs";
  };

  outputs =
    {
      flakelight,
      treefmt-nix,
      ...
    }@inputs:
    flakelight ./. {
      inherit inputs;
      imports = [
        flakelight.flakelightModules.extendFlakelight
        ./flakelight-treefmt.nix
      ];
      flakelightModule =
        { lib, ... }:
        {
          imports = [ ./flakelight-treefmt.nix ];
          inputs.treefmt-nix = lib.mkDefault treefmt-nix;
        };
      treefmtConfig =
        { lib, pkgs, ... }:
        {
          programs = {
            nixfmt.enable = true;
          };
          settings.formatter.rumdl = {
            command = lib.getExe pkgs.rumdl;
            options = [
              "fmt"
              "--"
            ];
            includes = [ "*.md" ];
          };
        };
    };
}
