#!/bin/bash
chroot "$1" chown root:root /etc/init/ttyS0.conf
chroot "$1" chmod 644       /etc/init/ttyS0.conf
