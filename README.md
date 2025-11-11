<!-- vim: set tw=72 spell nowrap: -->

# flakelight-treefmt

This module extends your [flakelight] project to replace the standard
flakelight formatter with one powered by [treefmt-nix].

## Usage

A minimal example looks like this:

```nix
{
  inputs.flakelight-treefmt.url = "github:m15a/flakelight-treefmt";
  outputs =
    { self, flakelight-treefmt, ... }:
    flakelight-treefmt ./. {
      inputs.self = self;
      treefmtConfig = {
        programs.nixfmt.enable = true;
      };
    };
}
```

> [!IMPORTANT]
> You must inherit `inputs.self` so that treefmt-nix can locate and
> check the files within your project.

You can also use this module with other flakelight modules.
An example with [flakelight-rust] would be:

```nix
{
  inputs = {
    flakelight-rust.url = "github:accelbread/flakelight-rust";
    flakelight-treefmt.url = "github:m15a/flakelight-treefmt";
    flakelight-treefmt.inputs.flakelight.follows = "flakelight-rust/flakelight";
  };
  outputs =
    { self, flakelight-rust, flakelight-treefmt, ... }:
    flakelight-rust ./. {
      inputs.self = self;
      imports = [ flakelight-treefmt.flakelightModules.default ];
      treefmtConfig = { pkgs, ... }: {
        programs.rustfmt.enable = true;
      };
    };
}
```

## Options

### `treefmtConfig`

Your configuration for treefmt-nix. It can be either an inline module
containing `programs.*` etc. (like the example above) or a path to a
configuration file (e.g., `./treefmt.nix`).

### `treefmtWrapperInDevShell`

Controls whether the `treefmt` command is added to `devShell.packages`.
The default value is `true`.

### `treefmtProgramsInDevShell`

Controls whether all formatters/linters configured via `treefmtConfig`
(e.g., `nixfmt`) are added to `devShell.packages`.
The default value is `true`.

## License

[The BSD 3-clause license](LICENSE).

[flakelight]: https://github.com/nix-community/flakelight
[flakelight-rust]: https://github.com/accelbread/flakelight-rust
[treefmt-nix]: https://github.com/numtide/treefmt-nix
