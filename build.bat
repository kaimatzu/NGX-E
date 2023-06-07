@echo off

rem !!!IMPORTANT!!!
rem Custom build system v1.0.0
rem Download MinGW-w64 on your system for some utility commands. If you don't, good luck building this piece of shit engine.
rem !!!IMPORTANT!!!

rem Initialize start time
set "start_time=%time%"

rem Set the paths and filenames
set source_dir=src
set object_dir=temp
set target_dir=bin

set dll_file=%target_dir%\NGXE.dll
set lib_file=%target_dir%\NGXE.lib
set def_file=NGXE.def
set exp_file=%target_dir%\NGXE.exp

rem !!!IMPORTANT!!!
rem ADD THE BIN DIRECTORIES OF THE TARGET APPLICATIONS HERE!
set target_applications_bin=..\TestApp\bin
rem !!!IMPORTANT!!!

set vendor_includes=vendor\spdlog\include
rem Set the preprocessor definitions
set CPPFLAGS=-I%source_dir%\NGXE -I%vendor_includes% -DNGXE_PLATFORM_WINDOWS -DNGXE_BUILD_DLL

rem Create the object files directory if it doesn't exist
if not exist %object_dir% mkdir %object_dir%

rem Create the target directory if it doesn't exist
if not exist %target_dir% mkdir %target_dir%

rem Loop through the CPP files in the source directory and its subdirectories
setlocal enabledelayedexpansion

rem Create a lock file to synchronize access to the files
echo. > lock.txt

for /R %source_dir% %%i in (*) do (
    rem Get the relative path, filename, and extension of the current CPP file
    set relative_path=%%~pi
    set file=%%~ni
    set ext=%%~xi

    
    if "!ext!"==".cpp" (
        rem Compile the CPP file into an object file in the object files directory
        echo Compiling: !file!!ext!
        g++ !CPPFLAGS! -c -std=c++11 -Wall -Wextra -march=native "%%i" -o "%object_dir%\!file!.o"
    )
)

echo Finished compiling...

rem Remove the global lock file
del lock.txt

endlocal

rem Create the DLL from the object files
echo Creating DLL file...
g++ -shared "%object_dir%\*.o" -o "%dll_file%"

rem Create the LIB file from the object files
echo Creating LIB files...
gendef "%dll_file%"
move "%def_file%" "%target_dir%"

rem Create the LIB file from the DEF file
dlltool -d "%target_dir%\%def_file%" -l "%lib_file%"

rem Generate the EXP file
dlltool -d "%target_dir%\%def_file%" -l "%exp_file%"

rem Clean up files
echo Cleaning up temp files and folders...
del /q "%object_dir%\*.o"
rd /s /q "%object_dir%"
del /Q "%target_dir%\%def_file%"

rem Copy DLL and LIB files in NGXE bin to target applications bin
echo Copying DLL and LIB files to target applications bin...

setlocal enabledelayedexpansion

for %%i in (%target_applications_bin%) do (
  for %%j in ("%target_dir%\*") do (
    echo Creating file %%~nj%%~xj in %%i
    if exist "%%i\%%~nj%%~xj" do del "%%i\%%~nj%%~xj" 2>nul
    copy %%j %%i
  )
)

endlocal

rem -------------------BUILD TIME TRACKER-------------------
rem Calculate execution time
set "end_time=%time%"
set "start_hour=%start_time:~0,2%"
set "start_min=%start_time:~3,2%"
set "start_sec=%start_time:~6,2%"
set "end_hour=%end_time:~0,2%"
set "end_min=%end_time:~3,2%"
set "end_sec=%end_time:~6,2%"
set /A "hour_diff=%end_hour%-%start_hour%"
set /A "min_diff=%end_min%-%start_min%"
set /A "sec_diff=%end_sec%-%start_sec%"

rem Format execution time
if %sec_diff% LSS 0 (
  set /A "min_diff-=1"
  set /A "sec_diff+=60"
)
if %min_diff% LSS 0 (
  set /A "hour_diff-=1"
  set /A "min_diff+=60"
)
if %hour_diff% LSS 0 (
  set /A "hour_diff+=24"
)

rem Display execution time
echo Build execution time: %hour_diff%hr:%min_diff%m:%sec_diff%s
echo Build complete. The DLL, LIB, and EXP files are located in the %target_dir% folder.
