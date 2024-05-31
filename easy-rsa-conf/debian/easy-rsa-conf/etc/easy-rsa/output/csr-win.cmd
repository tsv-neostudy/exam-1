#Run this script on client's Windows computer firstly.
#It will download and install OpenVPN client and will generate csr-file (certificate send request), and saved it on the user's Desktop
#Send the file to system administrator and wait response.

@echo on
REM OpenVPN program download, install and make dirs in current UserProfile
curl "https://swupdate.openvpn.org/community/releases/OpenVPN-2.6.10-I001-amd64.msi" --output "%temp%\openvpn.msi"
msiexec /i "%temp%\openvpn.msi" ADDLOCAL=OpenVPN.GUI,OpenVPN.Service,OpenVPN.Documentation,OpenVPN.SampleCfg,OpenSSL,EasyRSA,OpenVPN,OpenVPN.GUI.OnLogon,Drivers,Drivers.TAPWindows6,Drivers.Wintun  /passive
del "%temp%\openvpn.msi"
mkdir "%userprofile%\OpenVPN\config" "%userprofile%\OpenVPN\log"

REM Create csr.tmp file
set CONF_DIR=%userprofile%\OpenVPN\config
set CSR_TEM=%CONF_DIR%\csr.tmp
set /p "email=Enter your e-mail, please: "

@echo [ req ] > "%CSR_TEM%"
@echo prompt = yes >> "%CSR_TEM%"
@echo distinguished_name = dn >> "%CSR_TEM%"
@echo req_extensions = ext >> "%CSR_TEM%"

@echo [dn] >> "%CSR_TEM%"
@echo commonName = Common Name >> "%CSR_TEM%"
@echo commonName_default = vpn.sb.stumasov.ru >> "%CSR_TEM%"

@echo countryName = Country Name >> "%CSR_TEM%"
@echo countryName_default = RU >> "%CSR_TEM%"

@echo localityName = City >> "%CSR_TEM%"
@echo localityName_default = Moscow >> "%CSR_TEM%"

@echo organizationName = Organization >> "%CSR_TEM%"
@echo organizationName_default = sb.stumasov.ru >> "%CSR_TEM%"

@echo organizationUnitName = Department >> "%CSR_TEM%"
@echo organizationUnitName = IT >> "%CSR_TEM%"

@echo emailAddress = Email >> "%CSR_TEM%"
@echo emailAddress_default = %email% >> "%CSR_TEM%"

@echo [ext] >> "%CSR_TEM%"
@echo subjectAltName = DNS:www.sb.stumasov.ru,DNS:sb.stumasov.ru >> "%CSR_TEM%"

set path=%path%;"%programfiles%\OpenVPN\bin"

REM User secret key generation
openssl ecparam -genkey -name prime256v1 -out "%CONF_DIR%\secret.key"

REM user secret key encription
REM openssl ec -aes256 -in "%CONF_DIR%\secret.key" -out "%CONF_DIR%\secret.key"

REM certificare send request preparing
openssl req -new -config "%CSR_TEM%" -key "%CONF_DIR%\secret.key" -out "%CONF_DIR%\%email%.csr"
tar -cvf "%userprofile%\Desktop\send-to-admin.tar.gz" -C "%CONF_DIR%" "%email%.csr"
del "%CSR_TEM%" "%CONF_DIR%\%email%.csr"
echo "Script is finished."
exit
