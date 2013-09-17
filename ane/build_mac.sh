export AIRSDK=/opt/airsdk
gcc -I ${AIRSDK}/include -dynamiclib -o mac/libMacOS.framework \
-m32 -O3 -ffast-math \
-F "${AIRSDK}/runtimes/air/mac" -framework "Adobe AIR" \
../libwebp/src/dec/alpha.c \
../libwebp/src/dec/buffer.c \
../libwebp/src/dec/frame.c \
../libwebp/src/dec/idec.c \
../libwebp/src/dec/io.c \
../libwebp/src/dec/layer.c \
../libwebp/src/dec/quant.c \
../libwebp/src/dec/tree.c \
../libwebp/src/dec/vp8.c \
../libwebp/src/dec/vp8l.c \
../libwebp/src/dec/webp.c \
../libwebp/src/dsp/cpu.c \
../libwebp/src/dsp/dec.c \
../libwebp/src/dsp/dec_sse2.c \
../libwebp/src/dsp/upsampling_sse2.c \
../libwebp/src/dsp/lossless.c \
../libwebp/src/dsp/upsampling.c \
../libwebp/src/dsp/yuv.c \
../libwebp/src/demux/demux.c \
../libwebp/src/mux/muxedit.c \
../libwebp/src/mux/muxinternal.c \
../libwebp/src/mux/muxread.c \
../libwebp/src/utils/bit_reader.c \
../libwebp/src/utils/bit_writer.c \
../libwebp/src/utils/color_cache.c \
../libwebp/src/utils/filters.c \
../libwebp/src/utils/huffman.c \
../libwebp/src/utils/huffman_encode.c \
../libwebp/src/utils/quant_levels.c \
../libwebp/src/utils/rescaler.c \
../libwebp/src/utils/thread.c \
../libwebp/src/utils/utils.c \
../libwebp/src/utils/quant_levels_dec.c \
webp_extension.c
