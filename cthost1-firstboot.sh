#!/bin/bash

# rename root device to uuid in fstab
eval $(blkid -o export /dev/vda1)
echo "UUID=$UUID / ext4 defaults 0 0" >> /etc/fstab

# work around bugginess in setting up encrypted swap
eval $(blkid -o export /dev/vda2)
echo "/dev/mapper/cryptswap1 none swap noauto,sw 0 0" >> /etc/fstab
echo "cryptswap1 UUID=$UUID /dev/urandom noauto,offset=6,swap,cipher=aes-cbc-essiv:sha256" >> /etc/crypttab

# start cryptswap1 manually
/sbin/cryptdisks_start cryptswap1
/sbin/swapon /dev/mapper/cryptswap1

# erase traces of firstboot
mv /etc/rc.local.orig /etc/rc.local
