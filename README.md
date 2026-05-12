# podmania/base

Shared base image for all [podmania](https://github.com/podmania) containers, built with [nix2container](https://github.com/nlewo/nix2container).

## What's included

### Production image (`base-image`)

A minimal rootfs with the common runtime dependencies needed by every application image:

- **CA certificates** — TLS/SSL trust store for HTTPS connections
- **Timezone data** — zoneinfo database for timezone-aware applications
- **`/usr/bin/env`** — required by many shebangs and scripts
- **Minimal NSS** — `/etc/passwd` and `/etc/group` entries for root and nobody

### Debug image (`base-debug-image`)

Extends the production image with a comprehensive set of diagnostic tools:

`bash` `coreutils` `findutils` `grep` `sed` `awk` `curl` `wget` `iproute2` `iputils` `netcat` `dnsutils` `socat` `procps` `strace` `lsof` `less` `file` `tree` `tar` `gzip` `bzip2` `xz` `zstd` `jq` `which` `nano` `vim`

## Usage

Application images inherit from this base by adding it as a flake input:

```nix
inputs = {
  base.url = "github:podmania/base";
};
```

Then use `base.packages.${system}.base-image` as `fromImage` in `n2c.buildImage`, or use `base-debug-image` for development/debugging.

### Tags

| Tag | Description |
|-----|-------------|
| `latest` | Production image (minimal) |
| `latest-debug` | Debug image with diagnostic tools |

This image is not intended to be run directly.

<a href="https://www.buymeacoffee.com/bhoehn" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>
