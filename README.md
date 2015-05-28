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
```
encrypted home dir:
http://blog.dustinkirkland.com/2011/02/long-overdue-introduction-ecryptfs.html

encrypted swap:
https://blog.sleeplessbeastie.eu/2012/05/23/ubuntu-how-to-encrypt-swap-partition/

```
sudo apt-get install aptitude vagrant tmux git build-essential bash-completion openvpn bridge-utils
```

## virt-install

virt-install, to run the iso install process and have an encrypted filesystem.
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

Encrypted home directory.
Should get encrypted swap too.

Change `/etc/ssh/sshd_config` AuthorizedKeysFile dir, to use some other dir.

https://help.ubuntu.com/community/SSH/OpenSSH/Keys#Troubleshooting

e.g.:
```
sudo mkdir /etc/ssh/userkeys
sudo mkdir /etc/ssh/userkeys/<user>
sudo chmod 700 !$
cat > !$/authorized_keys
chmod 600 !$
sudo chmod u-w !$:h
sudo service ssh restart
```

Logging in via ssh will not decrypt your home dir, but:

http://stephen.rees-carter.net/thought/encrypted-home-directories-ssh-key-authentication

```
ssh in
sudo vim ~/.profile
# vim start
/usr/bin/ecryptfs-mount-private
cd $HOME
# vim end
```

```
andy@cthost1:~$ cat | sudo tee /etc/apt/apt.conf.d/02proxy
Acquire::http { Proxy "http://192.168.123.4:3142"; };

sudo aptitude install vagrant tmux git build-essential bash-completion openvpn bridge-utils
```

vim:nonu
