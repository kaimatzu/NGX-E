@echo off

rem !!!IMPORTANT!!!
rem Download MinGW-w64 on your system for some utility commands. If you don't, good luck building this piece of shit engine.
rem !!!IMPORTANT!!!

rem Set the paths and filenames
set source_dir=src
set object_dir=temp
set target_dir=bin
set dll_file=%target_dir%\NGEX.dll
set lib_file=%target_dir%\NGEX.lib
set def_file=NGEX.def
set exp_file=%target_dir%\NGEX.exp

rem Create the object files directory if it doesn't exist
if not exist %object_dir% mkdir %object_dir%

rem Create the target directory if it doesn't exist
if not exist %target_dir% mkdir %target_dir%

rem Loop through the CPP files in the source directory
for %%i in ("%source_dir%\*.cpp") do (
    rem Get the filename and extension of the current CPP file
    set file=%%~ni
    set ext=%%~xi

    rem Compile the CPP file into an object file in the object files directory
    g++ -c -std=c++11 -Wall -Wextra -march=native "%%i" -o "%object_dir%\!file!.o"
)


rem Create the DLL from the object files
g++ -shared "%object_dir%\*.o" -o "%dll_file%"


rem Create the LIB file from the object files
gendef "%dll_file%"
move "%def_file%" "%target_dir%"

rem Create the LIB file from the DEF file
dlltool -d "%target_dir%\%def_file%" -l "%lib_file%"

rem Generate the EXP file
dlltool -d "%target_dir%\%def_file%" -l "%exp_file%"

rem Clean up files
del /q "%object_dir%\*.o"
rd /s /q "%object_dir%"
del /Q "%target_dir%\%def_file%"

echo Build complete. The DLL, LIB, and EXP files are located in the %target_dir% folder.