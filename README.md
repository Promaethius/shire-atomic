# shire-atomic
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

sudo docker build -t deploy ./images/deploy
```

## Adding Packages
Edit `shire-atomic-host-base.json` by adding packages to the appropriate array.

## Rebasing
Run the deploy container and rebase to that address.
```
docker build -t atomic-deploy ./images/deploy
docker run -d --rm --name atomic-deploy -p 127.0.0.1:8000:8000 deploy
sudo ostree remote add shire-atomic-host http://127.0.0.1:8000 --no-gpg-verify
sudo rpm-ostree rebase shire-atomic-host:fedora/29/x86_64/shire-atomic-host
sudo rpm-ostree cleanup -r
```

