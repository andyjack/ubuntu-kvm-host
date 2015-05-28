#!/bin/bash

# based on https://github.com/hansode/vmbuilder/blob/master/kvm/rhel/6/examples/execscript.sh.example

# requires:
#  bash
#  chroot

set -x
set -e

echo "doing execscript.sh: $1"

cat <<'__EOF__' | chroot "$1" bash -c "cat | bash"
chown root:root /etc/init/ttyS0.conf /etc/init/cryptswap1.conf
chmod 644       /etc/init/ttyS0.conf /etc/init/cryptswap1.conf
/usr/bin/perl -ni -e 'next if m{/dev/sda1}; print' /etc/fstab
/usr/bin/perl -ni -e 'next if /swap/; print' /etc/fstab
__EOF__
