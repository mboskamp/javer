@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM setup
SET VERSION=0.0.1
SET CONFIG=.config
SET TEMP=temp
SET /a STATUS=0

REM set working dir
pushd %~dp0

IF NOT EXIST "%CONFIG%" COPY NUL %CONFIG%

REM inspect arguments

:help
SET h=false
IF [%~1]==[] SET h=true
IF [%~1]==[-h] SET h=true
IF [%~1]==[--help] SET h=true
IF [%h%]==[true] (
  ECHO javer usage:
  ECHO.
  ECHO -a/--add: Add a new Java installation to the list
  ECHO   usage: javer -a version path
  ECHO   example: javer -a 8 C:\java\jdk8
  ECHO.
  ECHO -r/--remove: Remove a Java installation from the list
  ECHO   usage: javer -r version
  ECHO   example: javer -r 8
  ECHO.
  ECHO -u/--use: Set JAVA_HOME to a Java installation from the list
  ECHO   usage: javer -u version
  ECHO   example: javer -u 8
  ECHO.
  ECHO -l/--list: Display all Java installations from the list
  ECHO   usage: javer -l
  ECHO   example: javer -l
  ECHO.
  ECHO -v/--version: Display the version of Javer and Java
  ECHO   usage: javer -v
  ECHO   example: javer -v

  GOTO :EOF
)

:add
SET a=false
IF [%~1]==[-a] SET a=true
IF [%~1]==[--add] SET a=true
IF [%a%]==[true] (
  IF [%~2]==[] SET /a STATUS=1
  IF [%~3]==[] SET /a STATUS=1
  IF !STATUS! GTR 0 GOTO error

  REM check if version already exists
  findstr /b "%~2|" %CONFIG% >NUL 2>&1
  IF !ERRORLEVEL!==0 (
    SET /a STATUS=2
	GOTO error
  )
  
  REM add entry to config
  ECHO %~2^|%~3>>%CONFIG%
  
  GOTO :EOF
)

:remove
SET r=false
IF [%~1]==[-r] SET r=true
IF [%~1]==[--remove] SET r=true
IF [%r%]==[true] (
  IF [%~2]==[] SET /a STATUS=1
  IF !STATUS! gtr 0 GOTO error
  
  REM backup existing config, remove line, write new config
  MOVE /y %CONFIG% %CONFIG%_bak >NUL & findstr /b /v "%~2|" %CONFIG%_bak >%CONFIG%
  
  GOTO :EOF
)

:set
SET u=false
IF [%~1]==[-u] SET u=true
IF [%~1]==[--set] SET u=true
IF [%u%]==[true] (
  IF [%~2]==[] SET /a STATUS=1
  IF !STATUS! gtr 0 GOTO error
  
  REM find path to java installation
  FOR /f "tokens=*" %%i IN ('findstr /b "%~2|" %CONFIG%') DO (
    FOR /f "delims=| tokens=2" %%x IN ("%%i") DO (
      ENDLOCAL
	  REM set JAVA_HOME
	  SETX JAVA_HOME %%x
	  	GOTO :EOF
    )
  )
  SET STATUS=3
  GOTO error
)

:list
SET l=false
IF [%~1]==[-l] SET l=true
IF [%~1]==[--list] SET l=true
IF [%l%]==[true] (
  type %CONFIG%
  GOTO :EOF
)

:version
SET v=false
IF [%~1]==[-v] SET v=true
IF [%~1]==[--version] SET v=true
IF [%v%]==[true] (
  ECHO Javer: %VERSION%
  ECHO Java:
  CALL java -version
  GOTO :EOF
)

:error
IF %STATUS% gtr 0 (
  IF %STATUS%==1 ECHO Invalid usage. Type javer -h for more information.
  IF %STATUS%==2 ECHO Java version already exists. Remove it first before adding a new JDK.
  IF %STATUS%==3 ECHO No Java installation found for version %~2

  ECHO ended with status %STATUS%
)
