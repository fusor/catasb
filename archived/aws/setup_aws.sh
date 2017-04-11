#!/bin/sh
BLOCK_DEVICE_TMP="/dev/xvdb"
MOUNTPOINT_TMP="/tmp"

BLOCK_DEVICE_DOCKER="/dev/xvdc"
MOUNTPOINT_DOCKER="/var/lib/docker"

/sbin/mkfs.ext3 ${BLOCK_DEVICE_DOCKER}
echo "${BLOCK_DEVICE_DOCKER} ${MOUNTPOINT_DOCKER} ext3 defaults 0 0" | sudo tee -a /etc/fstab
mkdir -p ${MOUNTPOINT_DOCKER}
mount ${MOUNTPOINT_DOCKER}

/sbin/mkfs.ext3 ${BLOCK_DEVICE_TMP}
echo "${BLOCK_DEVICE_TMP} ${MOUNTPOINT_TMP} ext3 defaults 0 0" | sudo tee -a /etc/fstab
mkdir -p ${MOUNTPOINT_TMP}
mount ${MOUNTPOINT_TMP}
chown root:root /tmp
chmod -R 777 /tmp
chmod -R +t /tmp
restorecon -R /tmp
