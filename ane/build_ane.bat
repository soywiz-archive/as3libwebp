@ECHO OFF

SET AIRSDK=c:\dev\airsdk
SET NAME=libwebp

REM SET SIGNING_OPTIONS=-storetype pkcs12 -keystore test.p12 -storepass test
REM "%AIRSDK%\bin\adt.bat" -package -storetype pkcs12 -keystore test.p12 -storepass test -target ane %NAME%.ane extension.xml -swc %NAME%_ane.swc -platform Windows-x86 library.swf %NAME%_ane.dll
REM "%AIRSDK%\bin\adt.bat" -package %SIGNING_OPTIONS% -target ane %NAME%.ane extension.xml

SET PLATFORMS=
REM SET PLATFORMS=%PLATFORMS% -platformoptions platformoptions.xml

REM SET PLATFORMS=%PLATFORMS% -platform iPhone-ARM -C ios .
SET PLATFORMS=%PLATFORMS% -platform Android-ARM -C android .
SET PLATFORMS=%PLATFORMS% -platform Windows-x86 -C windows .
SET PLATFORMS=%PLATFORMS% -platform default -C default .

DEL library.swf 2> NUL
DEL %NAME%_ane.swc 2> NUL
DEL ..\bin\%NAME%.ane 2> NUL
CALL "%AIRSDK%\bin\acompc" -source-path as3 -include-sources as3 -optimize -swf-version 13 -output %NAME%_ane.swc
..\utils\7z -y e %NAME%_ane.swc library.swf 2> NUL > NUL
COPY /y library.swf windows\library.swf 2> NUL
COPY /y library.swf android\library.swf 2> NUL
COPY /y library.swf default\library.swf 2> NUL
DEL library.swf 2> NUL
REM CALL "%AIRSDK%\bin\adt" -package -target ane %NAME%.ane extension.xml -swc %NAME%_ane.swc %PLATFORMS%
CALL "%AIRSDK%\bin\adt" -package -target ane ..\bin\%NAME%.ane extension.xml -swc %NAME%_ane.swc %PLATFORMS%
DEL %NAME%_ane.swc 2> NUL
