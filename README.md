# Set up Linux Box

* 16GB, Intel G3258, MSI CSM-H87M-G43 motherboard
* 128GB samsung 840 evo
* install ubuntu 14.04 server
  * openssh server
  * static ip address and dns
  * bikeshed package for purge-old-kernels
  * molly-guard
  * cpu-checker
  * lvm2 to handle partitions for vms
    * https://wiki.ubuntu.com/Lvm

# KVM to hold various different servers

* https://help.ubuntu.com/community/KVM
* http://www.naturalborncoder.com/virtualization/2014/10/23/installing-and-running-kvm-on-ubuntu-14-04-part-1/
* get rid of virbr0:
  * http://www.cyberciti.biz/faq/linux-kvm-disable-virbr0-nat-interface/
* why can't I use --iso option?  I get mount point /proc doesn't exist
  * somewhere said to use full path to the ISO, still didn't work

```
sudo install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils virtinst lvm2
```

## Bridged Networking

Bridged Networking: https://help.ubuntu.com/community/KVM/Networking

## Add a local apt-cacher-ng to hold packages

http://www.tecmint.com/apt-cache-server-in-ubuntu/

## LVM

Let KVM machines use disk devices directly for performance.

Some ideas for the future: http://serverfault.com/a/677646

```
sudo pvcreate /dev/sda4
sudo pvcreate /dev/sdb4
sudo vgcreate vg-kyon-ssd /dev/sda4
sudo vgcreate vg-kyon-mech /dev/sdb4
```

# Host, in which we run vagrant.

Turtles, man.

## vmbuilder

```
sudo lvcreate -n cthost1 -L 48g vg-kyon-mech
sudo cthost1.sh
sudo virsh -c qemu:///system
   list --all
   start cthost1
   console cthost1
```

## openvpn

https://help.ubuntu.com/community/OpenVPN

Modify /etc/default/openvpn and change so it doesn't start openvpn automatically.

```
sudo openvpn --daemon --config /etc/openvpn/client.conf --writepid /run/openvpn.pid

sudo kill -TERM $(cat /run/openvpn.pid)
```

## kvm under kvm

```
cat /sys/module/kvm_intel/parameters/nested
# should be Y
```

http://www.lucainvernizzi.net/blog/2014/12/03/vagrant-and-libvirt-kvm-qemu-setting-up-boxes-the-easy-way/

```
curl -O -L https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.2_x86_64.deb
# aptitude vagrant was run, to get dependencies for newer vagrant
sudo aptitude build-dep ruby-libvirt
sudo dpkg -i vagrant_1.7.2_x86_64.deb
vagrant plugin install vagrant-libvirt
vagrant plugin install vagrant-mutate
vagrant plugin install vagrant-rekey-ssh
vagrant box add trusty64 https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box
vagrant mutate trusty64 libvirt
```

## virt-install

virt-install, to run the iso install process and have an encrypted filesystem.

vmbuilder process is easier.  This is here just for reference.
```
VMNAME=cthost1
sudo virt-install                                                       \
    --connect=qemu:///system                                            \
    --name=$VMNAME                                                      \
    --ram=4096                                                          \
    --location="$HOME/ISOs/ubuntu-14.04.2-server-amd64.iso"             \
    --os-type=linux                                                     \
    --os-variant=ubuntutrusty                                           \
    --disk /dev/mapper/vg--kyon--mech-cthost1,bus=virtio                \
    --graphics none                                                     \
    --extra-args='console=tty0 console=ttyS0,115200n8 serial'           \
    --network=bridge=br0,model=virtio
```

<!--
vim:nonu
-->
