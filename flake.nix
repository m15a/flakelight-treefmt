{
  inputs = {
    flakelight.url = "github:nix-community/flakelight";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "flakelight/nixpkgs";
  };

  outputs =
    { flakelight, treefmt-nix, ... }:
    flakelight ./. {
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
      treefmtConfig = {
        programs.nixfmt.enable = true;
        programs.mdformat.enable = true;
      };
    };
}
