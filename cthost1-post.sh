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

# rename root device to uuid in fstab
perl -ni -e 'next if m{/dev/sda1}; print' /etc/fstab
eval $(blkid -o export /dev/vda1)
echo "UUID=$UUID / ext4 defaults 0 0" >> /etc/fstab

# work around bugginess in setting up encrypted swap
perl -ni -e 'next if /swap/; print' /etc/fstab
eval $(blkid -o export /dev/vda2)
echo "/dev/mapper/cryptswap1 none swap noauto,sw 0 0" >> /etc/fstab
echo "cryptswap1 UUID=$UUID /dev/urandom noauto,offset=6,swap,cipher=aes-cbc-essiv:sha256" >> /etc/crypttab
__EOF__
