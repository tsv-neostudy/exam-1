#
# Regular cron jobs for the prometheus-mysqld-exporter package
#
0 4	* * *	root	[ -x /usr/bin/prometheus-mysqld-exporter_maintenance ] && /usr/bin/prometheus-mysqld-exporter_maintenance
