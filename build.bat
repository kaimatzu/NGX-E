@echo off

rem Set the paths and filenames
set source_dir=src
set object_dir=temp
set target_dir=bin
set dll_file=%target_dir%\NGEX.dll
set lib_file=%target_dir%\NGEX.lib

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
    gcc -c "%%i" -o "%object_dir%\!file!.o"
)

rem Create the DLL from the object files
gcc -shared "%object_dir%\*.o" -o "%dll_file%"
rem gcc -Wl,--out-implib,"%lib_file%" "%object_dir%\*.o"

rem Clean up the object files
del /Q "%object_dir%\*.o"

echo Build complete. The DLL and LIB files are located in the %target_dir% folder.