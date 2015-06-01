#!/bin/bash

VMNAME=cthost1
vmbuilder kvm ubuntu                                \
    --addpkg acpid                                  \
    --addpkg aptitude                               \
    --addpkg bash-completion                        \
    --addpkg build-essential                        \
    --addpkg curl                                   \
    --addpkg git                                    \
    --addpkg linux-image-generic                    \
    --addpkg man-db                                 \
    --addpkg manpages                               \
    --addpkg openssh-server                         \
    --addpkg openvpn                                \
    --addpkg tmux                                   \
    --addpkg vim                                    \
    --hostname=$VMNAME                              \
    --suite=trusty                                  \
    --flavour=virtual                               \
    --libvirt qemu:///system                        \
    --mem=6656                                      \
    --raw=/dev/mapper/vg--kyon--mech-cthost1a       \
    --part="$PWD/cthost1-partitions"                \
    --proxy=http://192.168.123.4:3142               \
    --bridge=br0                                    \
    --ip=192.168.123.12                             \
    --mask=255.255.255.0                            \
    --dns=192.168.123.2                             \
    --gw=192.168.123.2                              \
    --user=andy                                     \
    --name=andy                                     \
    --pass=$VMNAME                                  \
    --dest="$HOME/vm/$VMNAME"                       \
    --templates="templates"                         \
    --copy="copy_files.txt"                         \
    --execscript="$PWD/cthost1-post.sh"             \
    --firstboot="$PWD/cthost1-firstboot.sh"         \
    --ssh-user-key="$HOME/.ssh/authorized_keys"
