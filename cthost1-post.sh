#!/bin/bash

# based on https://github.com/hansode/vmbuilder/blob/master/kvm/rhel/6/examples/execscript.sh.example

# requires:
#  bash
#  chroot

set -x
set -e

echo "doing execscript.sh: $1"

cat <<'__EOF__' | chroot "$1" bash -c "cat | bash"
for F in /etc/init/ttyS0.conf /etc/apt/apt.conf.d/02proxy /etc/modprobe.d/99-local.conf ; do
    chown root:root "$F"
    chown 644       "$F"
done
/usr/bin/perl -ni -e 'next if m{/dev/sda1}; print'  /etc/fstab
/usr/bin/perl -ni -e 'next if /swap/; print'        /etc/fstab
/usr/bin/perl -ni -e 'next if m{/dummy}; print'     /etc/fstab
umount /dev/vda3
echo -e "t\n3\n8e\nw\np" | fdisk /dev/vda
__EOF__
