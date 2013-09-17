#!/bin/bash

rm library.swf 2> /dev/null
rm libwebp_ane.swc 2> /dev/null
rm ..\bin\libwebp.ane 2> /dev/null
/opt/airsdk/bin/acompc -source-path as3 -include-sources as3 -optimize -swf-version 13 -output libwebp_ane.swc
7za -y e libwebp_ane.swc library.swf 2> /dev/null
cp -y library.swf windows\library.swf 2> /dev/null
cp -y library.swf android\library.swf 2> /dev/null
cp -y library.swf default\library.swf 2> /dev/null
rm library.swf 2> /dev/null
/opt/airsdk/bin/adt -package -target ane ..\bin\libwebp.ane extension.xml -swc libwebp_ane.swc \
	-platform Android-ARM -C android . \
	-platform Windows-x86 -C windows . \
	-platform default -C default .
DEL libwebp_ane.swc 2> /dev/null
