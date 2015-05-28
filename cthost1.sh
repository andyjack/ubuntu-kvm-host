#!/bin/bash

VMNAME=cthost1
vmbuilder kvm ubuntu                                \
    --addpkg openssh-server                         \
    --addpkg acpid                                  \
    --addpkg vim                                    \
    --addpkg linux-image-generic                    \
    --hostname=$VMNAME                              \
    --suite=trusty                                  \
    --flavour=virtual                               \
    --libvirt qemu:///system                        \
    --mem=6656                                      \
    --raw=/dev/mapper/vg--kyon--mech-cthost1        \
    --rootsize=42496                                \
    --swap=6656                                     \
    --proxy=http://192.168.123.4:3142               \
    --bridge=br0                                    \
    --ip=192.168.123.11                             \
    --mask=255.255.255.0                            \
    --dns=192.168.123.2                             \
    --user=andy                                     \
    --name=andy                                     \
    --pass=$VMNAME                                  \
    --dest="$HOME/vm/$VMNAME"                       \
    --templates="templates"                         \
    --copy="copy_files.txt"                         \
    --execscript="$PWD/cthost1-post.sh"             \
    --ssh-user-key="$HOME/.ssh/authorized_keys"
