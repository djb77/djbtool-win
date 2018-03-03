: DJBTool v1.06 Batch Script created by djb77 / XDA Developers
: Inspired and slightly based on APK-MuiltiTool by raziel23x / XDA Developers
: Build Date: 3rd March 2018

: INITIAL SETUP
: -------------
@echo off
cd "%~dp0"
if not exist "%~dp0files_decompiled/" (mkdir "%~dp0files_decompiled")
if not exist "%~dp0files_new/" (mkdir "%~dp0files_new")
if not exist "%~dp0files_original/" (mkdir "%~dp0files_original")
if not exist "%~dp0files_to_sign/" (mkdir "%~dp0files_to_sign")
if not exist "%~dp0framework/" (mkdir "%~dp0framework")
set djbtoolversion=1.06
set djbtoollog=%~dp0djbtool_log.log
title DJBTool v%djbtoolversion%
cls
if (%1)==(0) goto setup
@echo ----------------------------- >> %djbtoollog%
@echo DJBTool v%djbtoolversion% Log >> %djbtoollog%
@echo %date% -- %time% >> %djbtoollog%
@echo ----------------------------- >> %djbtoollog%
djbtool 0 2>> %djbtoollog%

:setup
mode con:cols=62 lines=40
setlocal enabledelayedexpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') do (
  set "DEL=%%a"
)
color 07
:setup2
set usrc=9
set resusrc=0
set dec=0
set capp=None
set heapy=1024
set jar=0
set errjar=0
java -version 
if errorlevel 1 set errjar=1
set /A count=0
for %%f in (files_original/*.apk) do (
set /A count+=1
set tmpstore=%%~nF%%~xF
)
for %%f IN (files_original/*.jar) do (
set /A count+=1
set tmpstore=%%~nF%%~xF
)
IF %count%==1 (set capp=%tmpstore%)
if exist "%programfiles(x86)%" (goto 64bit) else (goto 32bit)
:64bit
set 7zip=%~dp0tools\7za-x64.exe
goto mainmenu
:32bit
set 7zip=%~dp0tools\7za.exe

: MAIN MENU
: ---------
:mainmenu
title DJBTool v%djbtoolversion%
call :header
call :colorecho 0e "                      --- MAIN  MENU ---"
@echo.
@echo.
call :colorecho 0a " 1- "
@echo  Decompile one APK/JAR in files_original folder
call :colorecho 0a " 2- "
@echo  Decompile all APKs/JARs in files_original folder
@echo.
call :colorecho 0a " 3- "
@echo  Compile one APK/JAR in files_decompiled folder
call :colorecho 0a " 4- "
@echo  Compile all APKs/JARs in files_decompiled folder
@echo.
call :colorecho 0a " 5- "
@echo  Load Framework
call :colorecho 0a " 6- "
@echo  Sign Files
@echo.
call :colorecho 0a " 7- "
@echo  Clean files_decompiled folder
call :colorecho 0a " 8- "
@echo  Clean files_new folder
@echo.
call :colorecho 0a " 9- "
@echo  About Progarm
call :colorecho 0a " 0- "
@echo  Exit Progarm
@echo.
choice /c 1234567890 /n /m "Please select your option."
if %errorlevel%==1 goto decomp_file
if %errorlevel%==2 goto decomp_files
if %errorlevel%==3 goto comp_file
if %errorlevel%==4 goto comp_files
if %errorlevel%==5 goto load_framework
if %errorlevel%==6 goto sign_files
if %errorlevel%==7 goto clean_decompiled
if %errorlevel%==8 goto clean_new
if %errorlevel%==9 goto about
if %errorlevel%==10 goto exit
goto mainmenu

: DECOMPILE FILE
: --------------
:decomp_file
title DJBTool v%djbtoolversion% - Decompile 
call :header
call :colorecho 0e "                  --- DECOMPILE  FILES ---"
@echo.
@echo.
set /A count=0
for %%f in (files_original/*.apk files_original/*.jar) do (
set /A count+=1
set a!count!=%%f
if /I !count! leq 9 (@echo ^ !count!  - %%f )
if /I !count! gtr 9 (@echo ^ !count! - %%f )
)
@echo.
set /p input=Choose the file number you want to decompile: %=%
if errorlevel 1 goto mainmenu
if /I %input% gtr !count! (goto chc)
if /I %input% lss 1 (goto chc)
set capp=!a%input%!
set jar=0
set ext=jar
IF "!capp:%ext%=!" neq "%capp%" set jar=1
goto decomp_start
:chc
set capp=None
goto setup2
:decomp_start
@echo.
@echo Decompiling %capp%
cd %~dp0bin
if exist "%~dp0files_decompiled/%capp%" (rmdir /S /Q "%~dp0files_decompiled/%capp%")
java -Xmx%heapy%m -jar %~dp0bin/apktool.jar d -b %~dp0files_original/%capp% -o %~dp0files_decompiled/%capp% >nul
if errorlevel 1 (
@echo "An Error Occurred, Please Check The Log"
pause
)
cd ..
call :done

: DECOMPILE FILES
: ---------------
:decomp_files
title DJBTool v%djbtoolversion% - Decompile
call :header
call :colorecho 0e "                  --- DECOMPILE  FILES ---"
@echo.
@echo.
cd %~dp0files_original
for %%f in (*.apk) do (
@echo Decompiling %%f
cd %~dp0bin
if exist "%~dp0files_decompiled/%%f" (rmdir /S /Q "%~dp0files_decompiled/%%f")
java -Xmx%heapy%m -jar %~dp0bin/apktool.jar d -b %~dp0files_original/%%f -o %~dp0files_decompiled/%%f >nul
if errorlevel 1 (
@echo "An Error Occurred, Please Check The Log"
pause
)
)
cd %~dp0files_original
for %%f in (*.jar) do (
@echo Decompiling %%f
cd %~dp0bin
if exist "%~dp0files_decompiled/%%f" (rmdir /S /Q "%~dp0files_decompiled/%%f")
java -Xmx%heapy%m -jar %~dp0bin/apktool.jar d -b %~dp0files_original/%%f -o %~dp0files_decompiled/%%f >nul
if errorlevel 1 (
@echo "An Error Occurred, Please Check The Log"
pause
)
cd ..
)
call :done

: COMPILE FILE
: ------------
: comp_file
title DJBTool v%djbtoolversion% - Compile
call :header
call :colorecho 0e "                   --- COMPILE  FILES ---"
@echo.
@echo.
set /A count=0
for %%f in (files_original/*.apk files_original/*.jar) do (
set /A count+=1
set a!count!=%%f
if /I !count! leq 9 (@echo ^ !count!  - %%f )
if /I !count! gtr 9 (@echo ^ !count! - %%f )
)
@echo.
set /p input=Choose the file number you want to compile: %=%
if errorlevel 1 goto mainmenu
if /I %input% gtr !count! (goto chc)
if /I %input% lss 1 (goto chc)
set capp=!a%input%!
set jar=0
set ext=jar
if "!capp:%ext%=!" NEQ "%capp%" set jar=1
goto syscom
:chc
set capp=None
goto setup2
:syscom
if not exist "%~dp0files_decompiled\%capp%" goto dirnada
cd %~dp0bin
@echo.
@echo Compiling %capp%
mkdir %~dp0files_new
if exist "%~dp0files_new\%capp%" (del /Q "%~dp0files_new\%capp%")
java -Xmx%heapy%m -jar %~dp0bin/apktool.jar b "%~dp0files_decompiled/%capp%" -o "%~dp0files_new\%capp%" >nul
if (%jar%)==(0) (goto :nojar)
%7zip% x -o"%~dp0files_decompiled/temp" "%~dp0files_original/%capp%" META-INF -r >nul
%7zip% a -tzip "%~dp0files_new/%capp%" "%~dp0files_decompiled/temp/*" -mx%usrc% -r >nul
rmdir /S /Q "%~dp0%~dp0files_decompiled/temp"
goto mainmenu
:nojar
if errorlevel 1 (
echo "An Error Occurred, Please Check The Log"
pause
goto setup2
)
:nq1
@echo.
echo Aside from the files in META-INF,
choice /c YN /n /m "would you like to keep any other flies?(Y/N) "
if %errorlevel%==1 (call :syscom01)
if %errorlevel%==2 (call :syscom02)
:syscom01
rmdir /S /Q "%~dp0keep"
mkdir %~dp0keep
%7zip% x -o"%~dp0keep" "%~dp0files_original\%capp%" >nul
@echo.
echo A new folder called "keep" has been made in the 
echo main directory. Remove files that you don't want to keep.
pause
%7zip% a -tzip "%~dp0files_new/%capp%" "%~dp0keep/*" -mx%usrc% -r >nul
rmdir /S /Q "%~dp0keep"
%7zip% x -o"%~dp0files_decompiled/temp" "%~dp0files_new/%capp%" resources.arsc -r >nul
%7zip% a -tzip "%~dp0files_new/%capp%" "%~dp0files_decompiled/temp/resources.arsc" -mx%resusrc% -r >nul
rmdir /S /Q "%~dp0files_decompiled/temp"
cd ..
call :done
:syscom02
%7zip% x -o"%~dp0files_decompiled/temp" "%~dp0files_original/%capp%" META-INF -r >nul
%7zip% a -tzip "%~dp0files_new/%capp%" "%~dp0files_decompiled/temp/*" -mx%usrc% -r >nul
rmdir /S /Q "%~dp0files_decompiled/temp"
goto syscom03
:syscom03
@echo.
choice /c YN /n /m "Would you like to copy the AndroidManifest.xml (Y/N) "
if %errorlevel%==1 (call :syscom04)
if %errorlevel%==2 (call :syscom05)
:syscom04
%7zip% x -o"%~dp0files_decompiled/temp" "%~dp0files_original/%capp%" AndroidManifest.xml -r >nul
%7zip% a -tzip "%~dp0files_new/%capp%" "%~dp0files_decompiled/temp/AndroidManifest.xml" -mx%usrc% -r >nul
rmdir /S /Q "%~dp0files_decompiled/temp"
call :done
:syscom05
call :done

: COMPILE FILES
: -------------
: comp_files
title DJBTool v%djbtoolversion% - Compile
call :header
call :colorecho 0e "                   --- COMPILE  FILES ---"
@echo.
@echo.
set /A count=0
for /D %%f in (files_decompiled/*) do (
set /A count+=1
set a!count!=%%f
if /I !count! leq 9 (
echo Compiling %%f
if exist "%~dp0files_new\%%f" (del /Q "%~dp0files_new\%%f")
java -Xmx%heapy%m -jar %~dp0bin\apktool.jar b "%~dp0files_decompiled/%%f" -o "%~dp0files_new\%%f" >nul
%7zip% x -o"%~dp0files_decompiled/temp" "%~dp0files_original/%%f" META-INF -r >nul
%7zip% a -tzip "%~dp0files_new/%%f" "%~dp0files_decompiled/temp/*" -mx%usrc% -r >nul
rmdir /S /Q "%~dp0files_decompiled/temp"
)
if /I !count! gtr 10 (
echo Compiling %%f
if exist "%~dp0files_new\%%f" (del /Q "%~dp0files_new\%%f")
java -Xmx%heapy%m -jar %~dp0bin\apktool.jar b "%~dp0files_decompiled/%%f" -o "%~dp0files_new\%%f" >nul
%7zip% x -o"%~dp0files_decompiled/temp" "%~dp0files_original/%%f" META-INF -r >nul
%7zip% a -tzip "%~dp0files_new/%%f" "%~dp0files_decompiled/temp/*" -mx%usrc% -r >nul
rmdir /S /Q "%~dp0files_decompiled/temp"
)
)
call :done

: LOAD FRAMEWORK
: --------------
:load_framework
title DJBTool v%djbtoolversion% - Install Framework
call :header
call :colorecho 0e "                 --- INSTALL  FRAMEWORK ---"
@echo.
@echo.
@echo Please copy the following files from your firmware to the 
@echo "framework" folder
@echo.
@echo framework-res.apk (found in /system/framework)
@echo twframework-res.apk (found in /system/framework for MM)
@echo samsung-framework-res.apk (found in /system/framework/samsung-framework-res for N)
@echo SystemUI.apk (found in /system/priv-app/SystemUI)
@echo.
pause
@echo.
@echo Installing framework-res.apk
java -jar %~dp0bin/apktool.jar if %~dp0framework/framework-res.apk >nul
if exist %~dp0framework/twframework-res.apk (
@echo Installing twframework-res.apk
java -jar %~dp0bin/apktool.jar if %~dp0framework/twframework-res.apk >nul
)
if exist %~dp0framework/samsung-framework-res.apk (
@echo Installing samsung-framework-res.apk
java -jar %~dp0bin/apktool.jar if %~dp0framework/samsung-framework-res.apk >nul
)
@echo Installing SystemUI.apk
java -jar %~dp0bin/apktool.jar if %~dp0framework/SystemUI.apk >nul
call :done

: SIGN FILES
: ----------
:sign_files
title DJBTool v%djbtoolversion% - Sign Files
call :header
call :colorecho 0e "                    --- SIGNING FILES ---"
@echo.
@echo.
choice /c YN /n /m "Do you want to sign files in Files_New (Y/N) "
if %errorlevel%==1 goto copy_yes
if %errorlevel%==2 goto sign_files2
goto sign_files
:copy_yes
@echo.
xcopy /e /v /q /r /h /y %~dp0files_new\*.* %~dp0files_to_sign
:sign_files2
cd %~dp0files_to_sign
if exist "%~dp0files_to_sign\*.apk" (
call :colorecho 0e "Signing / Zipaligning APK Files ..."
@echo.
)
for %%f in (*.apk) do (
@echo Signing / Zipaligning %%f
ren %%f old%%f 
java -jar %~dp0bin\signapk.jar %~dp0bin/testkey.x509.pem %~dp0bin/testkey.pk8 old%%f %%f
del old%%f
ren %%f old%%f
%~dp0bin\zipalign.exe -f 4 old%%f %%f
del old%%f
)
for %%f in (*.jar *.zip) do (
@echo Signing %%f
ren %%f old%%f 
java -jar %~dp0bin\signapk.jar %~dp0bin/testkey.x509.pem %~dp0bin/testkey.pk8 old%%f %%f
del old%%f
)
cd ..
call :done

: CLEAN DECOMPILED
: ----------------
:clean_decompiled
title DJBTool v%djbtoolversion% - Clean
@echo.
choice /c YN /n /m "Are you sure you want to clean files_decompiled (Y/N) "
if %errorlevel%==1 goto cc_1
if %errorlevel%==2 goto cc_2
:cc_1
@echo.
@echo Deleting files in files_decompiled
del /f /q %~dp0files_decompiled
mkdir %~dp0files_decompiled
call :done
:cc_2
goto setup2

: CLEAN NEW
: ---------
:clean_new
title DJBTool v%djbtoolversion% - Clean
@echo.
choice /c YN /n /m "Are you sure you want to clean files_new (Y/N) "
if %errorlevel%==1 goto cn_1
if %errorlevel%==2 goto cc_2
:cn_1
@echo.
@echo Deleting files in files_new
del /f /q %~dp0files_new
mkdir %~dp0files_new
call :done

: ABOUT PROGRAM
: -------------
:about
title DJBTool v%djbtoolversion% - About
call :header
call :colorecho 0e "                   --- ABOUT  DJBTOOL ---"
@echo.
@echo.
type %~dp0bin\about
pause
goto setup2

: -----------
: SUBROUTINES
: -----------
:colorecho
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1i
exit /b

:header
cls
call :colorecho 03 "------------------------------------------------------------"
@echo.
call :colorecho 0b "                        DJBTool  v%djbtoolversion%"
@echo.
call :colorecho 03 "------------------------------------------------------------"
@echo.
if %errjar%==1 (
call :colorecho ce "Java is not working,  you won't be able to (de)compile files"
@echo.
)
@echo.
exit /b

:done
@echo.
call :colorecho 0f "Done ..."
@echo.
pause
goto setup2
exit /b

:exit
@echo.
call :colorecho 0f Goodbye ..."
@echo.
pause
exit
