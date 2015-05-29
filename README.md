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
sudo install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils virtinst

set up bridged networking: https://help.ubuntu.com/community/KVM/Networking

picking a storage format... difficult http://serverfault.com/questions/677639/which-is-better-image-format-raw-or-qcow2-to-use-as-a-baseimage-for-other-vms

# handy - add a local apt-cacher-ng to hold packages
http://www.tecmint.com/apt-cache-server-in-ubuntu/


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

/etc/fstab entries have /dev/sda instead of /dev/vda for some reason...
  https://bugs.launchpad.net/ubuntu/+source/vm-builder/+bug/517067

sudo apt-get install aptitude vagrant tmux git build-essential bash-completion openvpn bridge-utils
sudo aptitude install man-db manpages
```
### Encrypted Swap

https://blog.sleeplessbeastie.eu/2012/05/23/ubuntu-how-to-encrypt-swap-partition/

Encrypted swap is a pain, because of a bug:

http://askubuntu.com/questions/462775/swap-not-working-on-clean-14-04-install-using-encrypted-home

Fix:

https://bugs.launchpad.net/ubuntu/+source/ecryptfs-utils/+bug/1310058/comments/22

### Encrypted Home Dir

http://blog.dustinkirkland.com/2011/02/long-overdue-introduction-ecryptfs.html

Logging in via ssh will not decrypt your home dir, but:

http://stephen.rees-carter.net/thought/encrypted-home-directories-ssh-key-authentication

Separate user for using vagrant:
```
sudo adduser vagrant
sudo ecryptfs-migrate-home -u vagrant
login as vagrant before next reboot
add .ssh to decrypted home dir as usual
logout as vagrant

sudo mkdir -m 701 /home/vagrant/.ssh
sudo touch -m 644 /home/vagrant/.ssh/authorized_keys
echo '/usr/bin/ecryptfs-mount-private
cd $HOME' | sudo tee /home/vagrant/.profile
_EOF_
(copy in id_rsa.pub)
```

### openvpn

https://help.ubuntu.com/community/OpenVPN



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
