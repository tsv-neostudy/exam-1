# /etc/cron.d/file-bkp: crontab entries for the rsync package
#
# Backup will run twice a day
#
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/etc/file-bkp

05 0 * * * root /etc/file-bkp/backup.sh
