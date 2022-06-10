#!/bin/sh

set -e
set -x

mount /dev/sdb2 /mnt
mount /dev/sdb1 /mnt/boot
mount /dev/sdb3 /mnt/home
sudo rsync -aPAXH --delete --exclude="/lost+found" /rpios/ /mnt
umount /dev/sdb3
umount /dev/sdb1
umount /dev/sdb2
