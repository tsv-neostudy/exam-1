# /etc/cron.d/bkp-srv: crontab entries for delete backups older 6 month
#
# Script will run once a day
#
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/etc

30 0 * * * root find /mnt/bkp/ -maxdepth 1 -type d -ctime +180 -exec rm -rf {} \;

