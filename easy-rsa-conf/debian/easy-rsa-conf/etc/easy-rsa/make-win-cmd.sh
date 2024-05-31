#!/bin/bash

#run this script on the easy-rsa server when get csr-file from user

KEY_DIR="/etc/easy-rsa/pki"
REQS_DIR="${KEY_DIR}/reqs"
CERT_DIR="${KEY_DIR}/issued"
OUT_DIR="/etc/easy-rsa/output"
BASE_CONFIG=/etc/easy-rsa/pki/base.conf

read -p "Please, enter user's e-mail: " USER_NAME
while [ "${USER_NAME}" = "-----BEGIN CERTIFICATE REQUEST-----" ]
do
        read -p "Now need NOT CSR text, but user e-mail. please: " USER_NAME
done

echo "Please paste here the csr file text"
CRS_TEXT=""
while [ ! "$IN_TEXT" = "-----END CERTIFICATE REQUEST-----" ]
do
        read IN_TEXT
        CSR_TEXT+="${IN_TEXT}"$'\n'
done
echo "$CSR_TEXT" > "${REQS_DIR}/${USER_NAME}"

/etc/easy-rsa/easyrsa import-req "${REQS_DIR}/${USER_NAME}" "${USER_NAME}"
#rm "${REQS_DIR}/${USER_NAME}"
/etc/easy-rsa/easyrsa sign-req client "${USER_NAME}"

#############################################################
#make cmd-file for windows
#############################################################
IN_FILE_NAME="${BASE_CONFIG}"
OUT_FILE_NAME="${OUT_DIR}/${USER_NAME}.cmd"

echo @echo off > "${OUT_FILE_NAME}"
echo REM create ovpn-file >> "${OUT_FILE_NAME}"
echo set CONF_DIR=\%userprofile\%\\OpenVPN\\config >> "${OUT_FILE_NAME}"
echo set FILE_NAME=\%CONF_DIR\%\\"${USER_NAME}.ovpn" >> "${OUT_FILE_NAME}"
echo @echo \# Configuration file for OpenVPN \> \%FILE_NAME% >> "${OUT_FILE_NAME}"

while read line
do
        [ -z "${line}" ] && \
                echo @echo:  \>\> \%FILE_NAME\% >> "${OUT_FILE_NAME}" || \
                echo @echo ${line} \>\> \%FILE_NAME\%  >> "${OUT_FILE_NAME}"
done < "$IN_FILE_NAME"

############################################################
#make ovpn-file
############################################################
#cat ${BASE_CONFIG} \
#<(echo -e '<ca>') \
echo @echo ^\<ca^\> \>\> \%FILE_NAME\% >> "${OUT_FILE_NAME}"

#${KEY_DIR}/ca.crt \
IN_FILE_NAME="${KEY_DIR}/ca.crt"
while read line
do
        [ -z "${line}" ] && \
                echo @echo:  \>\> \%FILE_NAME\% >> "${OUT_FILE_NAME}" || \
                echo @echo ${line} \>\> \%FILE_NAME\%  >> "${OUT_FILE_NAME}"
done < "$IN_FILE_NAME"

#<(echo -e '</ca>\n<cert>') \
echo @echo ^\<^\/ca^\> \>\> \%FILE_NAME\% >> "${OUT_FILE_NAME}"
echo @echo ^\<cert^\> \>\> \%FILE_NAME\% >> "${OUT_FILE_NAME}"

#${CERT_DIR}/${USER_NAME}.crt \
IN_FILE_NAME="${CERT_DIR}/${USER_NAME}.crt"
while read line
do
        [ -z "${line}" ] && \
                echo @echo:  \>\> \%FILE_NAME\% >> "${OUT_FILE_NAME}" || \
                echo @echo ${line} \>\> \%FILE_NAME\%  >> "${OUT_FILE_NAME}"
done < "$IN_FILE_NAME"

#<(echo -e '</cert>\n<tls-crypt>') \
echo @echo ^\<^\/cert^\> \>\> \%FILE_NAME\% >> "${OUT_FILE_NAME}"
echo @echo ^\<tls-crypt^\> \>\> \%FILE_NAME\% >> "${OUT_FILE_NAME}"

#${KEY_DIR}/ta.key \
IN_FILE_NAME="${KEY_DIR}/ta.key"
while read line
do
        [ -z "${line}" ] && \
                echo @echo:  \>\> \%FILE_NAME\% >> "${OUT_FILE_NAME}" || \
                echo @echo ${line} \>\> \%FILE_NAME\%  >> "${OUT_FILE_NAME}"
done < "$IN_FILE_NAME"

#<(echo -e '</tls-crypt>') \
echo @echo ^\<^\/tls-crypt^\> \>\> \%FILE_NAME\% >> "${OUT_FILE_NAME}"

#> ${OUTPUT_DIR}/ovpn/${USER_NAME}.ovpn

#"${OUTPUT_DIR}/make-win-cmd.sh ${USER_NAME}"

echo @echo ^\<key^\> \>\> \%FILE_NAME\% >> "${OUT_FILE_NAME}"
echo type \%CONF_DIR\%\\secret.key \>\> \%FILE_NAME\% >> "${OUT_FILE_NAME}"
echo @echo ^\<^\/key^\> \>\> \%FILE_NAME\% >> "${OUT_FILE_NAME}"

echo \"\%PROGRAMFILES\%\\OpenVPN\\bin\\openvpn-gui.exe\" --command import \"\%FILE_NAME\%\" >> "${OUT_FILE_NAME}"

