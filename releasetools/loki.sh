#!/sbin/sh
#
# This leverages the loki_patch utility created by djrbliss which allows us
# to bypass the bootloader checks on jfltevzw and jflteatt
# See here for more information on loki: https://github.com/djrbliss/loki
#
#
# Run loki patch on boot.img for locked bootloaders, found in loki_bootloaders
#
# Update for MultiROM by Mattia "AntaresOne" D'Alleva
#

# Check ROM installation/upgrade:
# if touching primary ROM flash kernel in boot partition, else skip
busybox mount /system
export MROM=ls /tmp/META-INF/com/google/android | grep "updater-script"
busybox umount /system
if [ "$MROM" == "" ]; then
  echo "Installing primary ROM. Flashing kernel in boot partition..."
  egrep -q -f /system/etc/loki_bootloaders /proc/cmdline
  if [ $? -eq 0 ];then
    echo '[*] Locked bootloader version detected.'
    export C=/tmp/loki_tmpdir
    mkdir -p $C
    dd if=/dev/block/platform/msm_sdcc.1/by-name/aboot of=$C/aboot.img
    echo '[*] Patching boot.img to with loki.'
    /system/bin/loki_tool patch boot $C/aboot.img /tmp/boot.img $C/boot.lok || exit 1
    echo '[*] Flashing modified boot.img to device.'
    /system/bin/loki_tool flash boot $C/boot.lok || exit 1
    rm -rf $C
  else
    echo '[*] Unlocked bootloader version detected.'
    echo '[*] Flashing unmodified boot.img to device.'
    dd if=/tmp/boot.img of=/dev/block/platform/msm_sdcc.1/by-name/boot || exit 1
  fi
else
  echo "Installing ROM in MultiROM. Skipping kernel flash..."
fi
exit 0
