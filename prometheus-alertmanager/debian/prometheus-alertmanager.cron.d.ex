#
# Regular cron jobs for the prometheus-alertmanager package
#
0 4	* * *	root	[ -x /usr/bin/prometheus-alertmanager_maintenance ] && /usr/bin/prometheus-alertmanager_maintenance
