#
# Regular cron jobs for the openvpn-conf package
#
0 4	* * *	root	[ -x /usr/bin/openvpn-conf_maintenance ] && /usr/bin/openvpn-conf_maintenance
