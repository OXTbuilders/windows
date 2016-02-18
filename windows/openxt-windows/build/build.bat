set BUILDID=%1
set BRANCH=%2

rm -rf openxt
git clone git://github.com/OpenXT/openxt.git
cd openxt
git checkout %BRANCH%
cd windows

sed -i "s/Put Your Company Name Here/OpenXT/g" config\sample-config.xml

powershell .\winbuild-prepare.ps1 config=sample-config.xml build=%BUILDID% branch=%BRANCH% certname=developer developer=true
powershell .\winbuild-all.ps1

cd output
echo %BUILDID% > BUILD_ID
rsync --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r -a BUILD_ID sdk.zip win-tools.zip xctools-iso.zip xc-windows.zip builds@192.168.0.10:/home/builds/win/%BRANCH%/
rsync --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r -a xc-wintools.iso builds@192.168.0.10:/home/builds/builds/%BRANCH%/windows-tools/%BUILDID%/