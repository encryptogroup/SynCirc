{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    zig-overlay.url = "github:mitchellh/zig-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, zig-overlay }:
    (flake-utils.lib.eachDefaultSystem (system:

      let pkgs = nixpkgs.legacyPackages.${system}; in
      {

        devShell = pkgs.mkShell {
          buildInputs = [
            zig-overlay.packages.${system}."0.10.1"
            pkgs.yosys
          ];
        };

      }
    ));

}
