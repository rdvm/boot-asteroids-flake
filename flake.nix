{
  description = "A Nix flake with uv for boot.dev Asteroids project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        lib = pkgs.lib;

        go = pkgs.go_1_24;
        python = pkgs.python313;

        sdl2Packages = with pkgs; [
          SDL2
          SDL2_image
          SDL2_ttf
          SDL2_mixer
          SDL2_gfx
        ] ++ lib.optionals stdenv.isLinux [
          libGL
          mesa
          xorg.libX11
          xorg.libXext
          xorg.libXrandr
        ];

      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            go
            jq
            python
            uv
          ] ++ sdl2Packages;

          shellHook = ''
            [ ! -d .venv ] && uv venv --python ${python}/bin/python
            source .venv/bin/activate
            uv sync --frozen --quiet || true

            # Go
            export GOPATH="$HOME/go"
            export PATH="$GOPATH/bin:$PATH"

            # Linux runtime fixes
            ${lib.optionalString pkgs.stdenv.isLinux ''
              export LD_LIBRARY_PATH=${lib.makeLibraryPath sdl2Packages}:$LD_LIBRARY_PATH
              [ -z "$DISPLAY" ] && export DISPLAY=:0
            ''}

            echo "Nix devShell ready — $(python --version), $(go version), uv venv active"
          '';
        };
      });
}
