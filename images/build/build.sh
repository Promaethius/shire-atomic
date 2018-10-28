#!/bin/bash

set -ex

FILELS=$(ls /manifests/*-atomic-host.json)
FILE=${FILELS[0]}

ostree --repo=/srv/repo init --mode=archive-z2
rpm-ostree compose tree  --cachedir=/srv  --repo=/srv/repo $FILE

tar -zcfh /manifests/repo.tar.gz /srv/repo
