@echo off

rem Set the paths and filenames
set source_dir=src
set object_dir=temp
set target_dir=bin
set header_dir=..\..\NGXE\src

set executable_file=%target_dir%\output.exe

set dll_file=%target_dir%\NGXE.dll
set lib_file=%target_dir%\NGXE.lib
set exp_file=%target_dir%\NGXE.exp

set vendor_includes=..\..\NGXE\vendor\spdlog\include

rem Set the preprocessor definitions
set CPPFLAGS=-I%header_dir% -I%vendor_includes% -DNGXE_PLATFORM_WINDOWS 
setlocal enabledelayedexpansion
rem Include all subdirectories of header_dir to look for header files
for /R "%header_dir%" /D %%i in (*) do (
    set include_dir=%%~nxi
    set CPPFLAGS=!CPPFLAGS! -I%header_dir%\!include_dir!
)

rem Create the object files directory if it doesn't exist
if not exist %object_dir% mkdir %object_dir%

rem Create the target directory if it doesn't exist
if not exist %target_dir% mkdir %target_dir%

rem Loop through the CPP files in the source directory

for /R %source_dir% %%i in (*) do (
    rem Get the relative path, filename, and extension of the current CPP file
    set file=%%~ni
    set ext=%%~xi

    rem Compile the CPP file into an object file in the object files directory
    if "!ext!"==".cpp" (
        g++ !CPPFLAGS! -c -std=c++11 -Wall -Wextra -march=native -include src/ngxepch.h "%%i" -o "%object_dir%\!file!.o"
    )
)
endlocal

rem Link the object files into the executable in the target directory
g++ -Lbin "%object_dir%\*.o" -o "%executable_file%" -lNGXE -Wl,-rpath,"%%cd%%\bin"

rem Clean up the object files and delete temp
del /q "%object_dir%\*.o"
rd /s /q "%object_dir%"

@REM echo Build complete. The executable is located in the in the %target_dir% folder.