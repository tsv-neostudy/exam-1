#
# Regular cron jobs for the file-bkp package
#
0 4	* * *	root	[ -x /usr/bin/file-bkp_maintenance ] && /usr/bin/file-bkp_maintenance
