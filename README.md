# Nix Flake for boot.dev Asteroids Project

The _Build Asteroids using Python and Pygame_ semi-guided project on boot.dev
requires the use of `uv` for the `boot-cli` tests. I had some issues getting
pygame to actually open the game window on NixOS and figured I probably needed
some additional libraries/packages, so this is a flake meant to address that +
the `uv` requirement.

- Clone this repo
- "Detach" code from this repo and clear Git history
  - `cd boot-asteroids-flake`
  - `rm -rf .git`
- Initialize new Git repository
  - `git init`
- Stage files so `flake.nix` can be used (can also do initial commit of all
files if you want)
  - `git add .`
  - _(optional)_ `git commit -m "batman"`
    - "batman...because he ain't got no parents" - ThePrimeagen
- Enable `direnv` activation for the project
  - `direnv allow`
- Create virtual environment that will be activated automatically by direnv when
entering directory
  - `uv venv`
  - Manually activate as prompted with `source .venv/bin/activate` since we're
  already in the directory
- Install python packages
  - `uv sync`
