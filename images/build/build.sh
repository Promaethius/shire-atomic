#!/bin/bash

set -ex

ostree --repo=/srv/repo init --mode=archive-z2
rpm-ostree compose tree  --cachedir=/srv  --repo=/srv/repo /manifests/fedora-atomic-host.json
