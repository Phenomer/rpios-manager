#!/bin/sh

set -x
set -e

if [ `id -u` != "0" ]; then
  echo "Root privileges are required."
  exit 1
fi

if [ ! -z "`echo p | fdisk /dev/sdb | grep sdb1`" ]; then
  echo "Filesystem or Partition is already exist."
else
  echo "init filesystem."
  dd if=mbr.img of=/dev/sdb bs=512
  mkfs.vfat -n RPI_BOOT /dev/sdb1
  mkfs.ext4 -L RPI_ROOT /dev/sdb2
  mkfs.ext4 -L RPI_HOME /dev/sdb3
fi

sleep 3
mount /dev/sdb2 /mnt
mount /dev/sdb1 /mnt/boot
mount /dev/sdb3 /mnt/home

rsync -aPAXH --delete --exclude="/lost+found" /rpios/ /mnt
echo done.

umount /dev/sdb3
umount /dev/sdb1
umount /dev/sdb2

