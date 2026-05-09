# base

Shared base image for all podmania containers. Provides the common runtime dependencies needed by every application image:

- CA certificates (`caCertificates`)
- Timezone data (`tzdata`)
- `/usr/bin/env` (`usrBinEnv`)
- Minimal NSS (`fakeNss`)

Application images inherit from this via the `base` flake input and layer their package on top with `n2c.buildImage`.

This image is not intended to be run directly.

<a href="https://www.buymeacoffee.com/bhoehn" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>
