#!/bin/bash

LOG_PATH="/var/log/file-bkp.log"

INC_SRC_LIST="/etc/file-bkp/inc_files.list"
EXC_SRC_LIST="/etc/file-bkp/exc_files.list"

LAST_BKP=`tac "$LOG_PATH" | grep -m1 "created directory" | sed -r 's/^.*created directory //'`
OPT="-avHAX"
OPT+=" --log-file=${LOG_PATH}"
[ -z $LAST_BKP ] || OPT+=" --link-dest=../..${LAST_BKP}"
OPT+=" --files-from=${INC_SRC_LIST} --exclude-from=${EXC_SRC_LIST}"

DEST_SERV='rsync://bkp.sb.stumasov.ru'
DEST_DIR="backup/$(hostname)/$(date +%F--%H-%M-%S)/"

#make shure rhere's the destination store has a dir named as this server name
rsync -avHAX --filter="- *" --filter="- */" / "${DEST_SERV}/backup/$(hostname)"

#backup data
rsync `echo "${OPT}"` "/"  "${DEST_SERV}/${DEST_DIR}"

