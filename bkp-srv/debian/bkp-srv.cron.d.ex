#
# Regular cron jobs for the bkp-srv package
#
0 4	* * *	root	[ -x /usr/bin/bkp-srv_maintenance ] && /usr/bin/bkp-srv_maintenance
