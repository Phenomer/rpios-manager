#!/bin/sh

set -e
set -x

ROOT_DIR='/rpios'

cd `dirname ${0}`
if [ `id -u` != "0" ]; then
  echo "Root privileges are required."
  exit 1
fi

ARCHIVE_DATE=`curl -q -o- https://ftp.jaist.ac.jp/pub/raspberrypi/raspios_arm64/archive/ |
  grep -E -o 'href=\"\./[0-9:-]*/\"' |
  sed -e 's|href="./||' -e 's|/"||' |
  tail -n 1`
echo ${ARCHIVE_DATE}

umask 022
if [ ! -e 'boot.tar.xz' ]; then
  curl -o boot.tar.xz "https://ftp.jaist.ac.jp/pub/raspberrypi/raspios_arm64/archive/${ARCHIVE_DATE}/boot.tar.xz"
fi

if [ ! -e 'root.tar.xz' ]; then
  curl -o root.tar.xz "https://ftp.jaist.ac.jp/pub/raspberrypi/raspios_arm64/archive/${ARCHIVE_DATE}/root.tar.xz"
fi

tar xpf root.tar.xz -C "${ROOT_DIR}"
tar xpf boot.tar.xz -C "${ROOT_DIR}/boot"
