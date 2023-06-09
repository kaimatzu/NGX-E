@echo off

rem !!!IMPORTANT!!!
rem Download MinGW-w64 on your system for some utility commands. If you don't, good luck building this piece of shit engine.
rem !!!IMPORTANT!!!

rem Set the installation directory
set premake_dir=%cd%\premake\bin

echo %premake_dir%

rem Check if the installation directory is already in the PATH
echo %PATH% | find /I "%premake_dir%" > nul
if errorlevel 1 (
    rem Add the installation directory to the system PATH
    echo Premake found
    setx /M PATH "%premake_dir%;%PATH%"
    echo Installation directory added to PATH.
) else (
    echo Installation directory is already in PATH.
)

echo Dependencies installed.

pause