rem @echo off
rem *********************************
rem ** Obter certificados no site do ITI
rem ** http://www.iti.gov.br/icp-brasil/navegadores
rem ** Data do download: 05/06/2017
rem *********************************

call :_ExecutaInstalacao >%TEMP%\instala_certificado.log 2>&1
exit /b


:_ExecutaInstalacao

echo %date% %time% Iniciando a Instalacao dos Certificados 

set DIRPRINCIPAL=%CD%
set DIRCERTSW=%DIRPRINCIPAL%\certsw
set DIRCERTSJ=%DIRPRINCIPAL%\certsj

rem *********************************
rem ** adiciona as cadeias de certificados do ICP-Brasil no Windows
REM ** http://manuals.gfi.com/en/kerio/connect/content/server-configuration/ssl-certificates/adding-trusted-root-certificates-to-the-server-1605.html
rem *********************************

for %%A in (%DIRCERTSW%\*.*) do (
	certutil -addstore -f "ROOT" %%A
)

rem *********************************
rem ** adiciona as cadeias de certificados ao java
REM ** http://www.iti.gov.br/icp-brasil/navegadores/188-atualizacao/4736-cadeia-icpbrasil-java-windows-linux
rem *********************************

for /F "skip=1 tokens=*" %%A in ('wmic product where "name like 'Java 8%%'" get installlocation') do ( 
	set JAVADIR=%%A
	goto _SairFor
)
:_SairFor

set KEYTOOL="%JAVADIR: =%\BIN\keytool.exe"
set KEYSTORE="%JAVADIR: =%\lib\security\cacerts"
set SRCKEYSTORE="%DIRCERTSJ%\keystore_ICP_Brasil.jks"

%KEYTOOL% -importkeystore -srckeystore %SRCKEYSTORE% -srcstorepass 12345678 -destkeystore %KEYSTORE% -deststorepass changeit 


rem *********************************
rem ** informa ao firefox para utilizar os certificados do windows como confiaveis
REM ** https://wiki.mozilla.org/CA:AddRootToFirefox
rem *********************************


set PROFILE="%APPDATA%\Mozilla\Firefox\Profiles\*.default\"
set USERJS="user.js"

cd /D %PROFILE%

if exist %USERJS% (
	findstr "security.enterprise_roots.enabled" %USERJS%
	if ERRORLEVEL 1 echo pref("security.enterprise_roots.enabled", true^) >> %USERJS%
)

if not exist %USERJS% (
	echo pref("security.enterprise_roots.enabled", true^) >> %USERJS%
)

cd /D %DIRPRINCIPAL%

echo %date% %time% Fim da Instalacao dos Certificados
 
