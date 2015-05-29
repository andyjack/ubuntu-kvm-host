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

# set proper partition type for lvm, can't do this from outside
umount /dev/vda3
echo -e "t\n3\n8e\nw\np" | fdisk /dev/vda
kpartx /dev/vda

### lvm for kvm storage pool
sudo pvcreate /dev/vda3
sudo vgcreate cthost1-vg /dev/vda3

### put andy user into group allowed to use kvm vm's
sudo usermod -G libvirtd -a andy

# erase traces of firstboot
mv /etc/rc.local.orig /etc/rc.local
