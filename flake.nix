{
  inputs = {
    flakelight.url = "github:nix-community/flakelight";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "flakelight/nixpkgs";
  };

  outputs =
    { flakelight, treefmt-nix, ... }:
    flakelight ./. {
      imports = [ flakelight.flakelightModules.extendFlakelight ];
      flakelightModule =
        { lib, ... }:
        {
          imports = [ ./flakelight-treefmt.nix ];
          inputs.treefmt-nix = lib.mkDefault treefmt-nix;
        };
    };
}
