{
  inputs = {
    flakelight.url = "github:nix-community/flakelight";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "flakelight/nixpkgs";
  };

  outputs =
    { flakelight, ... }:
    flakelight ./. {
      imports = [ flakelight.flakelightModules.extendFlakelight ];
      flakelightModule = ./flakelight-treefmt.nix;
    };
}
