#!/bin/bash
#ppa-update script 
#
EMAIL='mail@sb.stumasov.ru'

dpkg-scanpackages --multiversion . > Packages
gzip -k -f Packages

apt-ftparchive release . > Release
gpg --default-key "${EMAIL}" -abs -o - Release > Release.gpg
gpg --default-key "${EMAIL}" --clearsign -o - Release > InRelease

git add -A
git commit -m "update"
git push -u origin master


