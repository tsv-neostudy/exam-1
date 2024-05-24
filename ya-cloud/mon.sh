#!/bin/bash
yc compute instance create \
 --name mon --hostname mon \
 --zone=ru-central1-d \
 --network-interface subnet-name=private-subnet,ipv4-address=172.16.4.31 \
 --platform=standard-v2 --cores=2 --memory=1G --core-fraction=5 \
 --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2004-lts-oslogin,size=10G,auto-delete=true \
 --create-disk name=bkp-hdd,type=network-hdd,size=5G,device-name=hdd-for-backup \
 --metadata serial-port-enable=0 \
 --metadata-from-file ssh-keys="/home/ubuntu/.ssh/id_ed25519.pub" \
 --metadata-from-file user-data="/home/ubuntu/app/ya-cloud/user-data"

