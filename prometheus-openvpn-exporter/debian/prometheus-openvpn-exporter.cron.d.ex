#
# Regular cron jobs for the prometheus-openvpn-exporter package
#
0 4	* * *	root	[ -x /usr/bin/prometheus-openvpn-exporter_maintenance ] && /usr/bin/prometheus-openvpn-exporter_maintenance
