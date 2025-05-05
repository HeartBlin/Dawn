# Dawn - NixOS Configuration

This repo contains my personal NixOS configuration, managed with [flake-parts](https://github.com/hercules-ci/flake-parts)

## Structure
- [`flake.nix`](./flake.nix): Defines flake inputs and outputs. Goes to `parts`.
- [`parts/`](./parts/): Contains the flake definitons.
  - [`systems.nix`](./parts/systems.nix): Defines the NixOS configs for different hosts.
  - [`tests.nix`](./parts/tests.nix): Defines unit tests with `nix-unit`.
- [`hosts/`](./hosts/): Contains host specific configs.
  - [`Vega/`](./hosts/Vega/): Defines the "Vega" system, a `ROG G513IE` laptop.
- [`modules/`](./modules): Contains modules for every system.
  - [`common/`](./modules/common): Shared settings that every host will use.
  - [`packages/`](./modules/packages/): Modules for specific applications.
- [`lib/`](./lib): Contains reusable nix functions.
  - [`mkSystem.nix`](./lib/mkSystem.nix): Helper function to build the systems.
  - [`hyprUtils.nix`](./lib/hyprUtils.nix): Utilities for Hyprland config.
  - [`asusUtils.nix`](./lib/asusUtils.nix): Utilities for ASUS laptop config.
- [`tests/`](./tests): Contains unit test definitions for `lib` functions.

## Testing

This flake uses the `flake-parts` module from [`nix-unit`](https://github.com/nix-community/nix-unit) for testing. To invoke the defined tests, run:

```bash
nix flake check # nix-unit creates a `check` attribute automatically.
```

## Resources
Configurations where I got *inspired* from:

- [TheMaxMur](https://github.com/TheMaxMur/NixOS-Configuration)
- [fufexan](https://github.com/fufexan/dotfiles)
- [rxyhn](https://github.com/rxyhn/yuki)
- [NotAShelf](https://github.com/NotAShelf/nyx) _<sub>archive</sub>_

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.