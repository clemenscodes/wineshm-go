{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
  };
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    packages = {
      ${system} = {};
    };
    devShells = {
      ${system} = {
        default = pkgs.mkShellNoCC {
          buildInputs = with pkgs; [
            gcc
            gnumake
            go
            go-bindata
            wineWow64Packages.stagingFull
            pkgsCross.mingw32.stdenv.cc
            lsof
            fuse
          ];
          nativeBuildInputs = with pkgs; [
            pkg-config
          ];
          shellHook = ''
            export WINEPREFIX="$(pwd)/.wine"
            export SHMWRAPPER1_PATH="$(pwd)/assets/shmwrapper1.exe"
            export SHMWRAPPER2_PATH="$(pwd)/assets/shmwrapper2.bin"
          '';
        };
      };
    };
  };
}
