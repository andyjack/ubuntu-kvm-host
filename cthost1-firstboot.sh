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

### lvm for kvm storage pool
sudo pvcreate /dev/vda3
sudo vgcreate cthost1-vg /dev/vda3

### put andy user into group allowed to use kvm vm's
sudo usermod -G libvirtd -a andy
sudo virsh -c qemu:///system

# in virsh
VIRSH="virsh -c qemu:///system"
$VIRSH pool-define-as --name cthost1-vg --type logical
$VIRSH pool-start cthost1-vg
$VIRSH pool-autostart cthost1-vg

# erase traces of firstboot
mv /etc/rc.local.orig /etc/rc.local
