#!/bin/bash
# Original author: William Lam
# Reference: http://www.virtuallyghetto.com/2014/11/how-to-quickly-deploy-new-coreos-image-wvmware-tools-on-esxi.html

# Name of the CoreOS Cloud Config ISO
CLOUD_CONFIG_ISO=$2-config.iso

echo "Checking if mkisofs exists ..."
if ! which mkisofs > /dev/null 2>&1; then
	echo "Error: mkisofs does not exists on your system"
	exit 1
fi

TMP_CLOUD_CONFIG_DIR=/tmp/new-drive

echo "Build Cloud Config Settings ..."
mkdir -p ${TMP_CLOUD_CONFIG_DIR}/openstack/latest
cp $1 ${TMP_CLOUD_CONFIG_DIR}/openstack/latest/user_data

echo "Creating Cloud Config ISO ..."
# Predefined `config-2` volume label is a CoreOS requirement!
mkisofs -R -V config-2 -o ${CLOUD_CONFIG_ISO} ${TMP_CLOUD_CONFIG_DIR}
