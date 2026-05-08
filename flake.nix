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
      imageDigest = "sha256:47b2d72ff90843eb8a768b5c2f89b40741843b639d065b9b937b07cd59b479c6";
      sha256 = {
        x86_64-linux = "sha256-wlelEExOcYfbbOp0JUONbi0dcK/OTF3Ek4DpUxSB9BY=";
        aarch64-linux = "sha256-670JZ9ouvC3337nTNx7SU7FiYew7p0ghLjT0+wmwNV0=";
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
