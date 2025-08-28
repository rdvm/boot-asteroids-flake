# Nix Flake for boot.dev Asteroids Project

The _Build Asteroids using Python and Pygame_ semi-guided project on boot.dev
requires the use of `uv` for the `boot-cli` tests. I had some issues getting
pygame to actually open the game window on NixOS and figured I probably needed
some additional libraries/packages, so this is a flake meant to address that +
the `uv` requirement.

- Clone this repo
- `direnv allow` to enable `direnv` activation for the project
- `uv venv` to create virtual environment that will be activated automatically
by direnv
- `uv sync` to install python packages
