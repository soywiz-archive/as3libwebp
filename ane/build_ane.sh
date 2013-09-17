#!/bin/bash

rm library.swf
rm libwebp_ane.swc
rm ../bin/libwebp.ane
/opt/airsdk/bin/acompc -source-path as3 -include-sources as3 -optimize -swf-version 13 -output libwebp_ane.swc
7za -y e libwebp_ane.swc library.swf
cp -f library.swf windows/library.swf
cp -f library.swf mac/library.swf
cp -f library.swf android/library.swf
cp -f library.swf default/library.swf
rm library.swf
/opt/airsdk/bin/adt -package -target ane ..\bin\libwebp.ane extension.xml -swc libwebp_ane.swc \
	-platform Android-ARM -C android . \
	-platform Windows-x86 -C windows . \
	-platform MacOS-x86 -C mac . \
	-platform default -C default .
rm libwebp_ane.swc
