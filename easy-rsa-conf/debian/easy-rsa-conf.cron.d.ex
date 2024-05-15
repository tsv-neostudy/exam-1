#
# Regular cron jobs for the easy-rsa-conf package
#
0 4	* * *	root	[ -x /usr/bin/easy-rsa-conf_maintenance ] && /usr/bin/easy-rsa-conf_maintenance
