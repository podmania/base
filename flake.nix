{
  description = "Podmania Base Image";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    system = builtins.currentSystem;
    pkgs = nixpkgs.legacyPackages.${system};

    distrolessImage = {
      imageName = "gcr.io/distroless/static-debian13";
      imageDigest = "sha256:20bc6c0bc4d625a22a8fde3e55f6515709b32055ef8fb9cfbddaa06d1760f838";
      sha256 = {
        x86_64-linux = "sha256-nTtTRnFVT//TiopktoapC/GncNlI5I6jhf7CsHpCpFY=";
        aarch64-linux = "sha256-RMKwrKl6lMjNO5G4W5B1I9y10ToOMOS++G4E9/gvfSQ=";
      };
    };
  in {
    packages.${system} = {
      base-image = pkgs.dockerTools.buildImage {
        name = "base";
        tag = "latest";
        fromImage = pkgs.dockerTools.pullImage {
          inherit (distrolessImage) imageName imageDigest;
          sha256 = distrolessImage.sha256.${system};
        };
        runAsRoot = ''
          mkdir /app
          chown 65532:65532 /app
        '';
        config = {
          User = "65532";
          WorkingDir = "/app";
        };
      };
    };
    
    defaultPackage.${system} = self.packages.${system}.base-image;
  };
}
