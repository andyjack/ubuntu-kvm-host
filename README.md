# Set up Linux Box

* 16GB, Intel G3258, MSI CSM-H87M-G43 motherboard
* 128GB samsung 840 evo
* install ubuntu 14.04 server
  * openssh server
  * static ip address and dns

# KVM to hold various different servers

* https://help.ubuntu.com/community/KVM
* http://www.naturalborncoder.com/virtualization/2014/10/23/installing-and-running-kvm-on-ubuntu-14-04-part-1/
* get rid of virbr0:
  * http://www.cyberciti.biz/faq/linux-kvm-disable-virbr0-nat-interface/
* why can't I use --iso option?  I get mount point /proc doesn't exist

```
sudo install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils

set up bridged networking: https://help.ubuntu.com/community/KVM/Networking
```

# Host, in which we run vagrant.

Turtles, man.

```
VMNAME=cthost1
sudo vmbuilder kvm ubuntu                               \
                        --rootsize=40960                \
                        --addpkg openssh-server         \
                        --addpkg acpid                  \
                        --addpkg linux-image-generic    \
                        --hostname=$VMNAME              \
                        --suite=trusty                  \
                        --libvirt qemu:///system        \
                        --mem=4096                      \
                        --dest=vm/$VMNAME               \
                        --swap=6144                     \
                        --bridge=br0

stuff I need:

sudo apt-get install aptitude vagrant tmux git build-essential bash-completion openvpn bridge-utils
```


