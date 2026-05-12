{
  description = "Podmania Base Image";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix2container.url = "github:nlewo/nix2container";
  };

  outputs = { self, nixpkgs, nix2container }: let
    system = builtins.currentSystem;
    pkgs = nixpkgs.legacyPackages.${system};
    n2c = nix2container.outputs.packages.${system}.nix2container;
  in {
    packages.${system} = {
      base-image = n2c.buildImage {
        name = "base";
        tag = "latest";

        copyToRoot = with pkgs; [
          iana-etc
          tzdata
          dockerTools.usrBinEnv
          dockerTools.caCertificates
          dockerTools.fakeNss
        ];
        maxLayers = 1;
        config = {
          WorkingDir = "/app";
        };
      };

      base-debug-image = n2c.buildImage {
        name = "base";
        tag = "latest-debug";
        fromImage = self.packages.${system}.base-image;
        copyToRoot = pkgs.buildEnv {
          name = "debug-utils";
          paths = with pkgs; [
            bashInteractive
            coreutils
            findutils
            gnugrep
            gnused
            gawk
            curl
            wget
            iproute2
            iputils
            netcat
            bind.dnsutils
            socat
            procps
            strace
            lsof
            less
            file
            tree
            gnutar
            gzip
            bzip2
            xz
            zstd
            jq
            which
            nano
            vim
          ];
          pathsToLink = [ "/bin" "/sbin" ];
        };
        maxLayers = 5;
      };

      default = self.packages.${system}.base-image;
    };
  };
}
