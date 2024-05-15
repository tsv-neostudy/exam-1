#!/bin/bash

LOG_PATH="/var/log/file-bkp.log"

SRC_LIST="/etc/file-bkp/backup.list"

LAST_BKP=`tac "$LOG_PATH" | grep -m1 "created directory" | sed -r 's/^.*created directory //'`
OPT="-avHAX"
OPT+=" --log-file=${LOG_PATH}"
[ -z $LAST_BKP ] || OPT+=" --link-dest=${LAST_BKP}"
OPT+=" --files-from=${SRC_LIST}"

DEST_SERV='ubuntu@bkp.sb.stumasov.ru'
DEST_DIR="bkp/$(hostname)/$(date +%F--%H-%M-%S)"

rsync `echo "${OPT}"` -e ssh "/" `echo "${DEST_SERV}:${DEST_DIR}"` 
