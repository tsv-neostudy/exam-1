#!/bin/bash

LOG_PATH="/var/log/file-bkp.log"

WORK_DIR="/etc/file-bkp"

#DB backup
MYSQL_BKP_FILE="${WORK_DIR}/$(date +%Y-%m-%d_%H-%M)-mysql-all-databases.sql.lzma"

if [ $(systemctl is-active mysql) == 'active' ]
then
        mysqldump -u bkp_user -p12!@qwQW --flush-logs --delete-master-logs --single-transaction --all-databases | lzma > "${MYSQL_BKP_FILE}"
fi

INC_SRC_LIST="${WORK_DIR}/inc_bkp.list"
EXC_SRC_LIST="${WORK_DIR}/exc_bkp.list"

RSYNC_LAST_BKP=`tac "$LOG_PATH" | grep -m1 "created directory" | sed -r 's/^.*created directory //'`
OPT="-arvHAX"
OPT+=" --log-file=${LOG_PATH}"
[ -z $RSYNK_LAST_BKP ] || OPT+=" --link-dest=../..${RSYNC_LAST_BKP}"
OPT+=" --files-from=${INC_SRC_LIST} --exclude-from=${EXC_SRC_LIST}"

DEST_SERV='rsync://bkp.sb.stumasov.ru'
DEST_DIR="backup/$(hostname)/$(date +%F--%H-%M-%S)/"

#make shure rhere's the destination store has a dir named as this server name
rsync -avHAX --filter="- *" --filter="- */" / "${DEST_SERV}/backup/$(hostname)"

#backup data
rsync `echo "${OPT}"` "/"  "${DEST_SERV}/${DEST_DIR}"

#remove mysql backup file
if [ -f "${MYSQL_BKP_FILE}" ]
then
        rm -f "${MYSQL_BKP_FILE}"
fi

