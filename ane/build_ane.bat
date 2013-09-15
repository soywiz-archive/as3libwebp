@ECHO OFF

SET AIRSDK=c:\dev\airsdk

REM SET SIGNING_OPTIONS=-storetype pkcs12 -keystore test.p12 -storepass test
REM "%AIRSDK%\bin\adt.bat" -package -storetype pkcs12 -keystore test.p12 -storepass test -target ane libwebp.ane extension.xml -swc libwebp_ane.swc -platform Windows-x86 library.swf libwebp_ane.dll
REM "%AIRSDK%\bin\adt.bat" -package %SIGNING_OPTIONS% -target ane libwebp.ane extension.xml

SET PLATFORMS=
REM SET PLATFORMS=%PLATFORMS% -platformoptions platformoptions.xml

REM SET PLATFORMS=%PLATFORMS% -platform iPhone-ARM -C ios .
SET PLATFORMS=%PLATFORMS% -platform Android-ARM -C android .
SET PLATFORMS=%PLATFORMS% -platform Windows-x86 -C windows .
SET PLATFORMS=%PLATFORMS% -platform default -C default .

DEL library.swf 2> NUL
DEL libwebp_ane.swc 2> NUL
DEL ..\bin\libwebp.ane 2> NUL
CALL "%AIRSDK%\bin\acompc" -source-path as3 -include-sources as3 -optimize -swf-version 13 -output libwebp_ane.swc
..\utils\7z -y e libwebp_ane.swc library.swf 2> NUL > NUL
COPY /y library.swf windows\library.swf 2> NUL
COPY /y library.swf android\library.swf 2> NUL
COPY /y library.swf default\library.swf 2> NUL
DEL library.swf 2> NUL
REM CALL "%AIRSDK%\bin\adt" -package -target ane libwebp.ane extension.xml -swc libwebp_ane.swc %PLATFORMS%
CALL "%AIRSDK%\bin\adt" -package -target ane ..\bin\libwebp.ane extension.xml -swc libwebp_ane.swc %PLATFORMS%
DEL libwebp_ane.swc 2> NUL
