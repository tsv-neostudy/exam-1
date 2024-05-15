#
# Regular cron jobs for the prometheus-nginxlog-exporter package
#
0 4	* * *	root	[ -x /usr/bin/prometheus-nginxlog-exporter_maintenance ] && /usr/bin/prometheus-nginxlog-exporter_maintenance
