#!/usr/bin/env bash

set -xeuo pipefail

# Work around https://bugzilla.redhat.com/show_bug.cgi?id=1265295
# Also note the create-new-then-rename dance for rofiles-fuse compat
if ! grep -q '^Storage=persistent' /etc/systemd/journald.conf; then
    (cat /etc/systemd/journald.conf && echo 'Storage=persistent') > /etc/systemd.journald.conf.new
    mv /etc/systemd.journald.conf{.new,}
fi

# See: https://src.fedoraproject.org/rpms/glibc/pull-request/4
# Basically that program handles deleting old shared library directories
# mid-transaction, which never applies to rpm-ostree. This is structured as a
# loop/glob to avoid hardcoding (or trying to match) the architecture.
for x in /usr/sbin/glibc_post_upgrade.*; do
    if test -f ${x}; then
        ln -srf /usr/bin/true ${x}
    fi
done

# https://github.com/projectatomic/rpm-ostree/issues/1542#issuecomment-419684977
for x in /etc/yum.repos.d/*modular.repo; do
  sed -i -e 's,enabled=[01],enabled=0,' ${x}
done

# See machineid-compat in host-base.yaml.
# Since that makes presets run on boot, we need to have our defaults in /usr
ln -sfr /usr/lib/systemd/system/{multi-user,default}.target

# We're not using resolved yet
rm -f /usr/lib/systemd/system/systemd-resolved.service
# https://github.com/openshift/os/issues/191

# https://github.com/coreos/fedora-coreos-tracker/issues/18
# See also image.ks.
# Growpart /, until we can fix Ignition for separate /var
# (And eventually we want ignition-disks)
cat > /usr/libexec/growpart << 'EOF'
#!/bin/bash
set -euo pipefail
path=$1
shift
majmin=$(findmnt -nvr -o MAJ:MIN $path)
devpath=$(realpath /sys/dev/block/$majmin)
partition=$(cat $devpath/partition)
parent_path=$(dirname $devpath)
parent_device=/dev/$(basename ${parent_path})
# TODO: make this idempotent, and don't error out if
# we can't resize.
growpart ${parent_device} ${partition} || true
xfs_growfs /sysroot # this is already idempotent
touch /var/lib/growpart.stamp
EOF

chmod a+x /usr/libexec/growpart
cat > /usr/lib/systemd/system/growpart.service <<'EOF'
[Unit]
ConditionPathExists=!/var/lib/growpart.stamp
Before=sshd.service
[Service]
ExecStart=/usr/libexec/growpart /
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF

cat >/usr/lib/systemd/system-preset/42-shire.preset << EOF
enable firstboot-complete.service
enable growpart.service
EOF

cat > /etc/motd <<EOF
Shire Atomic (in development)
EOF

echo "Shire Atomic" > $(realpath /etc/os-release)
