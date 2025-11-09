{
  inputs = {
    flakelight.url = "github:nix-community/flakelight";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "flakelight/nixpkgs";
  };

  outputs =
    {
      self,
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
          inputs.self = lib.mkDefault self;
          inputs.treefmt-nix = lib.mkDefault treefmt-nix;
        };
      treefmtConfig = {
        programs.nixfmt.enable = true;
        programs.mdformat.enable = true;
      };
    };
}
