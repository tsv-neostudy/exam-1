#!/bin/bash
yc dns zone add-records --name int-dns --record "@ 600 A ${EXT_IP}"
yc dns zone add-records --name int-dns --record "www 600 A ${EXT_IP}"
