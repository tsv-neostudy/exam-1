#
# Regular cron jobs for the prometheus package
#
0 4	* * *	root	[ -x /usr/bin/prometheus_maintenance ] && /usr/bin/prometheus_maintenance
