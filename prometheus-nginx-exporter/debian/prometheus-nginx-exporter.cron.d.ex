#
# Regular cron jobs for the prometheus-nginx-exporter package
#
0 4	* * *	root	[ -x /usr/bin/prometheus-nginx-exporter_maintenance ] && /usr/bin/prometheus-nginx-exporter_maintenance
