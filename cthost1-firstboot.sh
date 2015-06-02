#!/bin/bash

### Device entries in fstab aren't correct.
# https://bugs.launchpad.net/ubuntu/+source/vm-builder/+bug/517067
# rename root device to uuid in fstab
eval $(/sbin/blkid -o export /dev/vda1)
echo "UUID=$UUID / ext4 defaults 0 0" >> /etc/fstab
# same for swap
eval $(/sbin/blkid -o export /dev/vda2)
echo "UUID=$UUID none swap sw 0 0" >> /etc/fstab
/sbin/swapon -a

aptitude update

# make vagrant-like
echo "vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

rm /etc/apt/apt.conf

# erase traces of firstboot
mv /etc/rc.local.orig /etc/rc.local
