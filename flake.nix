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
          config = { allowUnfree = true; };
        };

        lib = pkgs.lib;

        isDarwin = pkgs.stdenv.isDarwin;
        isLinux = pkgs.stdenv.isLinux;

        python = pkgs.python3;

        sdl2Packages = with pkgs; [
          SDL2
          SDL2_image
          SDL2_ttf
          SDL2_mixer
          SDL2_gfx
        ] ++ lib.optionals isLinux [
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
            ruff
            basedpyright
            uv
            python
          ] ++ sdl2Packages;

          shellHook =
            lib.optionalString isLinux ''
              export LD_LIBRARY_PATH=${lib.makeLibraryPath sdl2Packages}:$LD_LIBRARY_PATH
              [ -z "$DISPLAY" ] && export DISPLAY=:0
            '' +
            lib.optionalString isDarwin ''
              echo "macOS detected – SDL2 ready (frameworks auto-linked via nixpkgs)"
            '';
        };
      }
    );
}
