T05: check
	@echo "-------- libwebp --------"

	@echo && echo "Now compile a SWC and demo SWF"
	"$(FLASCC)/usr/bin/gcc" $(BASE_CFLAGS) \
		-O4 \
		\
		src/dec/alpha.c \
		src/dec/buffer.c \
		src/dec/frame.c \
		src/dec/idec.c \
		src/dec/io.c \
		src/dec/layer.c \
		src/dec/quant.c \
		src/dec/tree.c \
		src/dec/vp8.c \
		src/dec/vp8l.c \
		src/dec/webp.c \
		\
		src/dsp/cpu.c \
		src/dsp/dec.c \
		src/dsp/enc.c \
		src/dsp/lossless.c \
		src/dsp/upsampling.c \
		src/dsp/yuv.c \
		\
		src/enc/alpha.c \
		src/enc/analysis.c \
		src/enc/backward_references.c \
		src/enc/config.c \
		src/enc/cost.c \
		src/enc/filter.c \
		src/enc/frame.c \
		src/enc/histogram.c \
		src/enc/iterator.c \
		src/enc/layer.c \
		src/enc/picture.c \
		src/enc/quant.c \
		src/enc/syntax.c \
		src/enc/tree.c \
		src/enc/vp8l.c \
		src/enc/webpenc.c \
		src/enc/token.c \
		\
		src/demux/demux.c \
		\
		src/mux/muxedit.c \
		src/mux/muxinternal.c \
		src/mux/muxread.c \
		\
		src/utils/bit_reader.c \
		src/utils/bit_writer.c \
		src/utils/color_cache.c \
		src/utils/filters.c \
		src/utils/huffman.c \
		src/utils/huffman_encode.c \
		src/utils/quant_levels.c \
		src/utils/rescaler.c \
		src/utils/thread.c \
		src/utils/utils.c \
		src/utils/quant_levels_dec.c \
		\
		as3api.c \
		main.c \
		\
		-emit-swc=libwebp \
		-o libwebp.swc
	"$(FLEX)/bin/mxmlc" -static-link-runtime-shared-libraries -compiler.omit-trace-statements=false -library-path=libwebp.swc -debug=false swcdemo.as -o swcdemo.swf

include ../Makefile.common

clean:
	rm -f *.swf *.swc *.bc *.exe
