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

### put andy user into group allowed to use kvm vm's
usermod -G libvirtd -a andy

aptitude update

curl -O -L https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.2_x86_64.deb
dpkg -i vagrant_1.7.2_x86_64.deb

# erase traces of firstboot
mv /etc/rc.local.orig /etc/rc.local
