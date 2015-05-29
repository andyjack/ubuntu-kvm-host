#!/bin/bash

# based on https://github.com/hansode/vmbuilder/blob/master/kvm/rhel/6/examples/execscript.sh.example

# requires:
#  bash
#  chroot

set -x
set -e

echo "doing execscript.sh: $1"

cat <<'__EOF__' | chroot "$1" bash -c "cat | bash"
for F in /etc/init/ttyS0.conf /etc/apt/apt.conf.d/02proxy; do
    chown root:root "$F"
    chown 644       "$F"
done
/usr/bin/perl -ni -e 'next if m{/dev/sda1}; print' /etc/fstab
/usr/bin/perl -ni -e 'next if /swap/; print' /etc/fstab
__EOF__
