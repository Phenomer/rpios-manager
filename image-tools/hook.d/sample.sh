#!/bin/sh

# ホスト毎に実行されるカスタムスクリプトをhook.d/*.shに記述。
# Ansibleでどうにかするのが厄介なものをここにまとめる。

# 例: SD_DEVICE=/dev/sdb
echo SD_DEVICE=${SD_DEVICE}

# 例: SD_HOSTNAME=rpi01
echo SD_HOSTNAME=${SD_HOSTNAME}

# 例: SD_MNTPNT=/mnt/sdb
echo SD_MNTPNT=${SD_MNTPNT}

