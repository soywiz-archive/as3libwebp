@echo off

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
SET LIBWEBP=%LIBWEBP% ../libwebp/src/dsp/dec_sse2.c
SET LIBWEBP=%LIBWEBP% ../libwebp/src/dsp/upsampling_sse2.c
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

DEL *.obj
cl /O1 /Os /D_USRDLL /D_WINDLL /I"%AIRSDK%\include" %LIBWEBP% %WEBPEXT% "%AIRSDK%\lib\win\FlashRuntimeExtensions.lib" /MD /link /DLL /OUT:windows/WindowsLib.dll
DEL *.obj
DEL windows\*.lib
DEL windows\*.exp