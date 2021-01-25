@echo off
mode con:cols=90
title auto saving v1.0.0
call :read_settings %~dp0autosave_config.ini || exit /b 1
set /a i=0
IF NOT EXIST "%GAME_SAVE%\%AUTO%" ( 
echo missing save file 
set /a i = 1
)
IF %I% == 1 ( 
pause
exit /b 1 
 ) ELSE (
 echo STATUS %AUTO% OK
 )
IF NOT EXIST "%~dp0\save_backup\auto\" (  MD %~dp0\save_backup\auto\ )
IF %GAME_START% == yes (  
echo STATUS: Game start - yes  

IF NOT EXIST "%GAME_FOLDER%\" ( 
echo Game folder does not exist 
pause
exit /b 1 
)
IF NOT EXIST "%GAME_FOLDER%\%EXE_FILE%" ( 
echo Game exe file does not exist 
pause
exit /b 1 
)
echo Game running .....
start %GAME_FOLDER%\%EXE_FILE%

) ELSE IF %GAME_START% == no ( 
echo STATUS: Without running Game
 ) ELSE (
echo GAME_START - only yes/no
pause
exit /b 1 
 )

call :X
set curdate_y=0
For /R "%~dp0\save_backup\auto\" %%i In (%CURDATE_X%) Do (
 	IF Exist %%i (
		SET CURDATE_Y=%CURDATE_X%
		echo Auto auto_save scan in progress.... timeout %TIME_OUT% sec
	) ELSE (
	echo no file in auto save backup
	)
)
:Main loop
call :X
IF NOT %CURDATE_X% == %CURDATE_Y% (
echo %date% %time% - Copy File auto save
copy "%GAME_SAVE%"\%AUTO% %~dp0\save_backup\auto\%CURDATE_X%
SET CURDATE_Y=%CURDATE_X%
echo %CURDATE_X% Copy File auto save>>%~dp0\log.txt
)
timeout %TIME_OUT% > NUL
echo %TIME% Auto save scan in progress.... timeout %TIME_OUT% sec
goto Main loop 
rem /******************************************************/
:read_settings
set SETTINGSFILE=%1
if not exist %SETTINGSFILE% (
echo FAIL: missing configuration file
pause
exit /b 1
)
for /f "eol=# delims== tokens=1,2" %%i in (%SETTINGSFILE%) do (
set %%i=%%j
)
goto :eof
:X
for %%t in ("%GAME_SAVE%\%AUTO%") do set X=%%~tt
set curdate_x=%X:~0,2%%X:~3,2%%X:~6,2%%X:~9,2%%X:~12,2%
goto :eof
