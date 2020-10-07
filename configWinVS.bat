@ECHO off
REM run this on wsl using:
REM cmd.exe /C "configWinVS.bat VS15-Win64"

SET OMS_VS_TARGET=%~1
SET TARGET=%~2
IF NOT DEFINED TARGET SET TARGET=all

echo # Target: %TARGET%

IF ["%OMS_VS_TARGET%"]==["VS14-Win32"] SET OMS_VS_PLATFORM=32&& SET OMS_VS_VERSION="Visual Studio 14 2015"
IF ["%OMS_VS_TARGET%"]==["VS14-Win64"] SET OMS_VS_PLATFORM=64&& SET OMS_VS_VERSION="Visual Studio 14 2015 Win64"
IF ["%OMS_VS_TARGET%"]==["VS15-Win32"] SET OMS_VS_PLATFORM=32&& SET OMS_VS_VERSION="Visual Studio 15 2017"
IF ["%OMS_VS_TARGET%"]==["VS15-Win64"] SET OMS_VS_PLATFORM=64&& SET OMS_VS_VERSION="Visual Studio 15 2017 Win64"

IF NOT DEFINED OMS_VS_VERSION (
  ECHO No argument or unsupported argument given. Use one of the following VS version strings:
  ECHO   "VS14-Win32" for Visual Studio 14 2015
  ECHO   "VS14-Win64" for Visual Studio 14 2015 Win64
  ECHO   "VS15-Win32" for Visual Studio 15 2017
  ECHO   "VS15-Win64" for Visual Studio 15 2017 Win64
  GOTO fail
)

SET OMS_VS_TARGET
SET OMS_VS_VERSION
SET OMS_VS_PLATFORM
ECHO.

:: -- init ----------------------------
SET VSCMD_START_DIR="%CD%"

IF ["%OMS_VS_TARGET%"]==["VS14-Win32"] @CALL "%VS140COMNTOOLS%\..\..\VC\vcvarsall.bat" x86
IF ["%OMS_VS_TARGET%"]==["VS14-Win64"] @CALL "%VS140COMNTOOLS%\..\..\VC\vcvarsall.bat" x86_amd64
IF ["%OMS_VS_TARGET%"]==["VS15-Win32"] (
  IF EXIST "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" (
    @CALL "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x86
  ) ELSE (
    @CALL "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" x86
  )
)
IF ["%OMS_VS_TARGET%"]==["VS15-Win64"] (
  IF EXIST "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" (
    @CALL "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64
  ) ELSE (
    @CALL "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64
  )
)

IF NOT DEFINED CMAKE_BUILD_TYPE SET CMAKE_BUILD_TYPE="Release"

ECHO.
SET CMAKE_BUILD_TYPE
ECHO.
:: -- init ----------------------------

IF NOT EXIST build\\ mkdir build
IF NOT EXIST build\\win\\ mkdir build\\win
IF NOT EXIST install\\ MKDIR install
IF NOT EXIST install\\win MKDIR install\\win
IF NOT EXIST install\\win\\lib MKDIR install\\win\\lib

IF ["%TARGET%"]==["clean"] GOTO clean
IF ["%TARGET%"]==["gflags"] GOTO gflags
IF ["%TARGET%"]==["glog"] GOTO glog
IF ["%TARGET%"]==["ceres"] GOTO ceres
IF ["%TARGET%"]==["omsysident"] GOTO omsysident
IF ["%TARGET%"]==["all"] GOTO all
ECHO # Error: No rule to make target '%TARGET%'.
EXIT /B 1

:: -- clean ---------------------------
:clean
IF EXIST "build\win\" RMDIR /S /Q build\win && IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail
IF EXIST "install\win\" RMDIR /S /Q install\win && IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail
EXIT /B 0
:: -- clean ---------------------------

:: -- config gflags -------------------
:gflags
ECHO # config gflags
IF EXIST "3rdParty\gflags\build\win\" RMDIR /S /Q 3rdParty\gflags\build\win
IF EXIST "3rdParty\gflags\install\win\" RMDIR /S /Q 3rdParty\gflags\install\win
MKDIR 3rdParty\gflags\build\win
CD 3rdParty\gflags\build\win
cmake.exe -G %OMS_VS_VERSION% ..\..\gflags -DCMAKE_INSTALL_PREFIX=..\..\install\win -DBUILD_TESTING:BOOL=OFF -DCMAKE_BUILD_TYPE=Release
IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail
CD ..\..\..\..
ECHO # build gflags
msbuild.exe "3rdParty\gflags\build\win\INSTALL.vcxproj" /t:Build /p:configuration=Release /maxcpucount
IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail
EXIT /B 0
:: -- config gflags -------------------


:: -- config glog ---------------------
:glog
ECHO # config glog
IF EXIST "3rdParty\glog\build\win\" RMDIR /S /Q 3rdParty\glog\build\win
IF EXIST "3rdParty\glog\install\win\" RMDIR /S /Q 3rdParty\glog\install\win
MKDIR 3rdParty\glog\build\win
CD 3rdParty\glog\build\win
cmake.exe -G %OMS_VS_VERSION% ..\..\glog -DCMAKE_INSTALL_PREFIX=..\..\install\win -DBUILD_TESTING:BOOL=OFF -DCMAKE_BUILD_TYPE=Release
IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail
CD ..\..\..\..
ECHO # build glog
msbuild.exe "3rdParty\glog\build\win\INSTALL.vcxproj" /t:Build /p:configuration=Release /maxcpucount
IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail
EXIT /B 0
:: -- config glog ---------------------


:: -- config ceres-solver -------------
:ceres
ECHO # config ceres-solver
IF EXIST "3rdParty\ceres-solver\build\win\" RMDIR /S /Q 3rdParty\ceres-solver\build\win
IF EXIST "3rdParty\ceres-solver\install\win\" RMDIR /S /Q 3rdParty\ceres-solver\install\win
MKDIR 3rdParty\ceres-solver\build\win
CD 3rdParty\ceres-solver\build\win
cmake.exe -G %OMS_VS_VERSION% ..\..\ceres-solver -DCMAKE_INSTALL_PREFIX=..\..\install\win -DCXX11:BOOL=ON -DEXPORT_BUILD_DIR:BOOL=ON -DEIGEN_INCLUDE_DIR_HINTS="../../eigen/eigen" -DBUILD_EXAMPLES:BOOL=OFF -DBUILD_TESTING:BOOL=OFF -DCMAKE_BUILD_TYPE=Release
IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail
CD ..\..\..\..
ECHO # build ceres-solver
msbuild.exe "3rdParty\ceres-solver\build\win\INSTALL.vcxproj" /t:Build /p:configuration=Release /maxcpucount
IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail
EXIT /B 0
:: -- config ceres-solver -------------


:: -- config OMSysIdent --------------
:omsysident
ECHO # config OMSysIdent
IF EXIST "build\win\" RMDIR /S /Q build\win
MKDIR build\win
CD build\win
cmake.exe -G %OMS_VS_VERSION% ..\.. -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DCMAKE_BUILD_TYPE:STRING=%CMAKE_BUILD_TYPE%
IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail
CD ..\..
EXIT /B 0
:: -- config OMSysIdent --------------


:: -- config all ----------------------
:all
START /B /WAIT CMD /C "%~0 %OMS_VS_TARGET% clean"
IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail
START /B /WAIT CMD /C "%~0 %OMS_VS_TARGET% gflags"
IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail
START /B /WAIT CMD /C "%~0 %OMS_VS_TARGET% glog"
IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail
START /B /WAIT CMD /C "%~0 %OMS_VS_TARGET% ceres"
IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail
START /B /WAIT CMD /C "%~0 %OMS_VS_TARGET% omsysident"
IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail
EXIT /B 0
:: -- config all ----------------------


:fail
ECHO Error: Configuring failed for target '%TARGET%'.
EXIT /B 1
