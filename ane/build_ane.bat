@ECHO OFF

SET AIRSDK=c:\dev\airsdk

REM SET SIGNING_OPTIONS=-storetype pkcs12 -keystore test.p12 -storepass test
REM "%AIRSDK%\bin\adt.bat" -package -storetype pkcs12 -keystore test.p12 -storepass test -target ane libwebp.ane extension.xml -swc libwebp_ane.swc -platform Windows-x86 library.swf libwebp_ane.dll
REM "%AIRSDK%\bin\adt.bat" -package %SIGNING_OPTIONS% -target ane libwebp.ane extension.xml

SET PLATFORMS=
REM SET PLATFORMS=%PLATFORMS% -platformoptions platformoptions.xml

REM SET PLATFORMS=%PLATFORMS% -platform iPhone-ARM -C ios .
REM SET PLATFORMS=%PLATFORMS% -platform Android-ARM -C android .
SET PLATFORMS=%PLATFORMS% -platform Windows-x86 -C windows .
REM SET PLATFORMS=%PLATFORMS% -platform default -C default .

CALL "%AIRSDK%\bin\compc" -source-path as3 -include-libraries %AIRSDK%/frameworks/libs/air/airglobal.swc -include-sources as3 -optimize -swf-version 13 -output libwebp_ane.swc

CALL "%AIRSDK%\bin\adt" -package -target ane libwebp.ane extension.xml -swc libwebp_ane.swc %PLATFORMS%
