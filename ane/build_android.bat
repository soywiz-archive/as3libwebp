@ECHO OFF

PUSHD jni
CALL C:\Development\android-ndk-r6\ndk-build.cmd
POPD
COPY /Y libs\armeabi\libwebp_extension.so android\libAndroid.so
RD /S /Q libs

EXIT /B


:: C:\Development\Android NDK\toolchains\arm-linux-androideabi-4.6\prebuilt\windows\bin
:: arm-linux-androideabi-g++
::      -Iinclude -IC:\Development\Android NDK/sources/cpufeatures \
::      --sysroot=C:\Development\Android NDK/platforms/android-5/arch-arm
::     -IC:\Development\Android NDK/sources/cxx-stl/gnu-libstdc++/4.4.3/include
::     -IC:\Development\Android NDK/sources/cxx-stl/gnu-libstdc++/4.4.3/libs/armeabi/include
::     -DHXCPP_VISIT_ALLOCS
::     -IC:\HaxeToolkit\haxe\lib\hxcpp\3,0,2//include
::     -Iinclude
::     -fpic -fvisibility=hidden -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums
::     -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__ -D_LINUX_STDDEF_H
::     -Wno-psabi
::     -march=armv5te
::     -mtune=xscale -msoft-float
::     -fomit-frame-pointer -fexceptions -fno-strict-aliasing -finline-limit=10000
::     -DANDROID -Wa,--noexecstack -O2 -DNDEBUG -c -x c
::     ./webp/dec/frame.c -oobj/android/webp/dec/frame.obj
:: C:/Development/Android NDK/toolchains/arm-linux-androideabi-4.4.3/prebuilt/windows/bin/../lib/gcc/arm-linux-androideabi/4.4.3/../../../../arm-linux-androideabi/bin/ld.exe
:: C:\Development\Android NDK\toolchains\arm-linux-androideabi-4.4.3\prebuilt\windows\arm-linux-androideabi\bin\ld.exe
:: "C:\Development\Android NDK\toolchains\arm-linux-androideabi-4.4.3\prebuilt\windows\arm-linux-androideabi\bin\gcc.exe"

SET AIRSDK=c:\dev\airsdk

SET LIBWEBP=
SET LIBWEBP=%LIBWEBP% ../libwebp/src/dec/alpha.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/dec/buffer.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/dec/frame.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/dec/idec.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/dec/io.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/dec/layer.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/dec/quant.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/dec/tree.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/dec/vp8.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/dec/vp8l.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/dec/webp.c
SET LIBWEBP=%LIBWEBP%
SET LIBWEBP=%LIBWEBP% ../libwebp/src/dsp/cpu.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/dsp/dec.c
:: SET LIBWEBP=%LIBWEBP% ../libwebp/src/dsp/dec_sse2.c
:: SET LIBWEBP=%LIBWEBP% ../libwebp/src/dsp/upsampling_sse2.c
REM SET LIBWEBP=%LIBWEBP% ../libwebp/src/dsp/enc_sse2.c
REM SET LIBWEBP=%LIBWEBP% ../libwebp/src/dsp/enc.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/dsp/lossless.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/dsp/upsampling.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/dsp/yuv.c
SET LIBWEBP=%LIBWEBP%
REM SET LIBWEBP=%LIBWEBP% ../libwebp/src/enc/alpha.c
REM SET LIBWEBP=%LIBWEBP% ../libwebp/src/enc/analysis.c
REM SET LIBWEBP=%LIBWEBP% ../libwebp/src/enc/backward_references.c
REM SET LIBWEBP=%LIBWEBP% ../libwebp/src/enc/config.c
REM SET LIBWEBP=%LIBWEBP% ../libwebp/src/enc/cost.c
REM SET LIBWEBP=%LIBWEBP% ../libwebp/src/enc/filter.c
REM SET LIBWEBP=%LIBWEBP% ../libwebp/src/enc/frame.c
REM SET LIBWEBP=%LIBWEBP% ../libwebp/src/enc/histogram.c
REM SET LIBWEBP=%LIBWEBP% ../libwebp/src/enc/iterator.c
REM SET LIBWEBP=%LIBWEBP% ../libwebp/src/enc/layer.c
REM SET LIBWEBP=%LIBWEBP% ../libwebp/src/enc/picture.c
REM SET LIBWEBP=%LIBWEBP% ../libwebp/src/enc/quant.c
REM SET LIBWEBP=%LIBWEBP% ../libwebp/src/enc/syntax.c
REM SET LIBWEBP=%LIBWEBP% ../libwebp/src/enc/tree.c
REM SET LIBWEBP=%LIBWEBP% ../libwebp/src/enc/vp8l.c
REM SET LIBWEBP=%LIBWEBP% ../libwebp/src/enc/webpenc.c
REM SET LIBWEBP=%LIBWEBP% ../libwebp/src/enc/token.c
SET LIBWEBP=%LIBWEBP%
SET LIBWEBP=%LIBWEBP% ../libwebp/src/demux/demux.c
SET LIBWEBP=%LIBWEBP%
SET LIBWEBP=%LIBWEBP% ../libwebp/src/mux/muxedit.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/mux/muxinternal.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/mux/muxread.c
SET LIBWEBP=%LIBWEBP%
SET LIBWEBP=%LIBWEBP% ../libwebp/src/utils/bit_reader.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/utils/bit_writer.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/utils/color_cache.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/utils/filters.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/utils/huffman.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/utils/huffman_encode.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/utils/quant_levels.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/utils/rescaler.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/utils/thread.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/utils/utils.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/utils/quant_levels_dec.c

SET WEBPEXT=
SET WEBPEXT=%WEBPEXT% webp_extension.c


SET GCC="C:\Development\Android NDK\toolchains\arm-linux-androideabi-4.4.3\prebuilt\windows\bin\arm-linux-androideabi-gcc"
::SET GCC="C:\Development\Android NDK\toolchains\arm-linux-androideabi-4.4.3\prebuilt\windows\arm-linux-androideabi\bin\gcc.exe"

SET GCC_EXTRA=
SET GCC_EXTRA=%GCC_EXTRA% -Iinclude -I"C:\Development\Android NDK/sources/cpufeatures"
SET GCC_EXTRA=%GCC_EXTRA% --sysroot="C:\Development\Android NDK/platforms/android-5/arch-arm"
SET GCC_EXTRA=%GCC_EXTRA% -I"C:\Development\Android NDK/sources/cxx-stl/gnu-libstdc++/4.4.3/include"
SET GCC_EXTRA=%GCC_EXTRA% -I"C:\Development\Android NDK/sources/cxx-stl/gnu-libstdc++/4.4.3/libs/armeabi/include"
SET GCC_EXTRA=%GCC_EXTRA% -I"%AIRSDK%/include"
::SET GCC_EXTRA=%GCC_EXTRA% -l"%AIRSDK%\lib\android\FlashRuntimeExtensions.so"
SET GCC_EXTRA=%GCC_EXTRA% -Iinclude
:: SET GCC_EXTRA=%GCC_EXTRA%  -fpic -fvisibility=hidden -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums
SET GCC_EXTRA=%GCC_EXTRA% -fpic
SET GCC_EXTRA=%GCC_EXTRA% -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__ -D_LINUX_STDDEF_H
SET GCC_EXTRA=%GCC_EXTRA% -DENABLE_PROTECTION=OFF
SET GCC_EXTRA=%GCC_EXTRA% -Wno-psabi
SET GCC_EXTRA=%GCC_EXTRA% -march=armv5te
SET GCC_EXTRA=%GCC_EXTRA% -mtune=xscale -msoft-float
SET GCC_EXTRA=%GCC_EXTRA% -fomit-frame-pointer -fexceptions -fno-strict-aliasing -finline-limit=10000
SET GCC_EXTRA=%GCC_EXTRA% -DANDROID -Wa,--noexecstack -O2 -DNDEBUG -x c


%GCC% -shared -o android/libAndroid.so %GCC_EXTRA% %LIBWEBP% %WEBPEXT%
