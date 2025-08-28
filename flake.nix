{
  description = "A Nix flake with uv for boot.dev Asteroids project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python3;
        # Define Python packages managed by uv
        pythonPackages = python.withPackages (ps: with ps; [
          # additional Python packages here if needed
        ]);
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            ruff
            pyright
            python
            pythonPackages
            uv
            SDL2
            SDL2_image
            SDL2_ttf
            SDL2_mixer
            SDL2_gfx
            libGL
            mesa # OpenGL support
            mesa-demos # For glxinfo debugging
            xorg.libX11 # X11 dependencies for SDL
            xorg.libXext
            xorg.libXrandr
          ];

          shellHook = ''
            # Set up environment variables for SDL and X11
            export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [
              pkgs.SDL2
              pkgs.SDL2_image
              pkgs.SDL2_ttf
              pkgs.SDL2_mixer
              pkgs.SDL2_gfx
              pkgs.libGL
              pkgs.mesa
              pkgs.xorg.libX11
              pkgs.xorg.libXext
              pkgs.xorg.libXrandr
            ]}:$LD_LIBRARY_PATH
            # Ensure DISPLAY is set (adjust if needed)
            export DISPLAY=:0
          '';
        };
      }
    );
}
