@echo off

rem !!!IMPORTANT!!!
rem Download MinGW-w64 on your system for some utility commands. If you don't, good luck building this piece of shit engine.
rem !!!IMPORTANT!!!

rem Set the installation directory
set install_dir=C:\NGEXutils\

rem Create the installation directory if it doesn't exist
if not exist "%install_dir%" mkdir "%install_dir%"

rem Utilities:
if not exist "%install_dir%\implib.exe" (
    echo Downloading dependencies...
    curl -o "%install_dir%\implib.exe" "http://ftp.digitalmars.com/bup.zip"
)

rem Check if the installation directory is already in the PATH
echo %PATH% | find /I "%install_dir%" > nul
if errorlevel 1 (
    rem Add the installation directory to the system PATH
    setx /M PATH "%install_dir%;%PATH%"
    echo Installation directory added to PATH.
) else (
    echo Installation directory is already in PATH.
)

echo Dependencies installed.

pause