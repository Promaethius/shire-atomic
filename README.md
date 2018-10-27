# shire-atomic
[![Build Status](https://travis-ci.org/Promaethius/shire-atomic.svg?branch=master)](https://travis-ci.org/Promaethius/shire-atomic)
## Practical Kubernetes
* Based on the Fedora 29 RPM atomic host.
* Implements CoreOS philosophy by removing all interpreted language dependencies.
* Ignition instead of Cloud-Init.
* Cri-O and rkt instead of docker.
* Bare-bones package list.
* Custom Fedora Kernel optimized for power savings and long term processes.

## Building
```
docker build -t build images/build
docker run --rm --privileged -v ./shire-atomic:/manifests -v ./images/deploy/repo:/srv build
```

## Adding Packages
Edit `shire-atomic-host-base.json` by adding packages to the appropriate array.
