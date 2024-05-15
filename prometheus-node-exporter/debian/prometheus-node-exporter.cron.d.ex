#
# Regular cron jobs for the prometheus-node-exporter package
#
0 4	* * *	root	[ -x /usr/bin/prometheus-node-exporter_maintenance ] && /usr/bin/prometheus-node-exporter_maintenance
