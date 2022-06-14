#!/bin/sh

#set -x
set -e

SD_DEVICE="${1}"
SD_DEVNAME=`basename "${SD_DEVICE}"`
SD_HOSTNAME="${2}"
SD_MNTPNT="/mnt/${SD_DEVNAME}"
export SD_DEVICE
export SD_DEVNAME
export SD_HOSTNAME
export SD_MNTPNT

cd `dirname ${0}`
if [ `id -u` != "0" ]; then
  echo "Root privileges are required."
  exit 1
fi

if [ -z "${2}" ]; then
  echo "${0} SDCARD_DEVICE HOSTNAME"
  echo "example: ${0} /dev/sdb rpi01"
  exit 2
fi

if [ ! -e "${SD_DEVICE}" ]; then
  echo Device "${SD_DEVICE}" is not found.
  exit 3
fi

FDISK_RESULT=`echo p | fdisk ${SD_DEVICE}`
echo "${FDISK_RESULT}"

if [ ! -z "`echo ${FDISK_RESULT} | grep ${SD_DEVNAME}1`" ]; then
  echo "Filesystem or Partition is already exist."
else
  echo "init filesystem."
  dd if=mbr.img of="${SD_DEVICE}" bs=512
  mkfs.vfat -n RPI_BOOT "${SD_DEVICE}1"
  mkfs.ext4 -L RPI_ROOT "${SD_DEVICE}2"
  mkfs.ext4 -L RPI_HOME "${SD_DEVICE}3"
fi

sleep 3
mkdir -p -m 0755 "${SD_MNTPNT}"
echo mount "${SD_DEVICE}2" to "${SD_MNTPNT}"
mount "${SD_DEVICE}2" "${SD_MNTPNT}"
echo mount "${SD_DEVICE}1" to "${SD_MNTPNT}/boot"
mount "${SD_DEVICE}1" "${SD_MNTPNT}/boot"
echo mount "${SD_DEVICE}3" to "${SD_MNTPNT}/home"
mount "${SD_DEVICE}3" "${SD_MNTPNT}/home"

rsync -aPAXH --delete --exclude="/lost+found" /rpios/  "${SD_MNTPNT}"

for SCRIPT in hook.d/*.sh; do
  ./${SCRIPT}
done

echo umount "${SD_DEVICE}3"
umount "${SD_DEVICE}3"
echo umount "${SD_DEVICE}1"
umount "${SD_DEVICE}1"
echo umount "${SD_DEVICE}2"
umount "${SD_DEVICE}2"
