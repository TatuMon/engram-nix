{
  description = "Persistent memory for AI coding agents";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        engram = pkgs.buildGoModule rec {
          pname = "engram";
          version = "3.7.2";
          vendorHash = "sha256-hkwwuqar4ngDUWM2XctkiVm8TpfQWnUws/sDxDyvQxU=";

          nativeBuildInputs = [
            pkgs.git
          ];
          doCheck = false;
          ldflags = [
            "-s"
            "-w"
            "-X main.version=${version}"
          ];

          subPackages = [ "cmd/engram" ];
          src = pkgs.fetchFromGitHub {
            owner = "Gentleman-Programming";
            repo = "engram";
            rev = "v${version}";
            hash = "sha256-8vychLARVy7Ry+7hXx+NxnUR0KIUC5nJA+1XFduDB/M=";
          };

          meta = with pkgs.lib; {
            description = "Persistent memory for AI coding agents";
            homepage = "https://github.com/Gentleman-Programming/engram";
            license = licenses.mit;
            mainProgram = "engram";
            platforms = platforms.linux ++ platforms.darwin;
          };
        };
      in
      {
        packages.default = engram;
        packages.engram = engram;

        apps.default = flake-utils.lib.mkApp {
          drv = engram;
        };
      }
    );
}
