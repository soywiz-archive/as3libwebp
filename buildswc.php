<?php

class BuildLib {
	private $baseFiles;
	private $encodeFiles;
	private $allDecodeFiles;
	private $allEncodeFiles;
	private $FLASCC = '/Developer/crossbridge/sdk';
	private $FLEX = '/Developer/airsdk15getenv';

	public function __construct() {
		$this->baseFiles = [
			"dec/alpha.c", "dec/buffer.c", "dec/frame.c", "dec/idec.c", "dec/io.c", "dec/quant.c", "dec/tree.c",
			"dec/vp8.c", "dec/vp8l.c", "dec/webp.c", "dsp/cpu.c", "dsp/dec.c", "dsp/lossless.c", "dsp/upsampling.c",
			"dsp/alpha_processing.c", "dsp/dec_clip_tables.c", "dsp/yuv.c", "demux/demux.c", "utils/bit_reader.c",
			"utils/color_cache.c", "utils/filters.c", "utils/huffman.c", "utils/rescaler.c", "utils/thread.c",
			"utils/random.c", "utils/utils.c", "utils/quant_levels_dec.c"
		];

		$this->encodeFiles = [
			"dsp/enc.c", "enc/alpha.c", "enc/analysis.c", "enc/backward_references.c", "enc/picture_csp.c", "enc/config.c",
			"enc/cost.c", "enc/filter.c", "enc/frame.c", "enc/histogram.c", "enc/iterator.c", "enc/picture.c", "enc/quant.c",
			"enc/syntax.c", "enc/tree.c", "enc/vp8l.c", "enc/webpenc.c", "enc/token.c", "mux/muxedit.c", "mux/muxinternal.c",
			"mux/muxread.c", "utils/bit_writer.c", "utils/huffman_encode.c", "utils/quant_levels.c",
		];

		$this->sse2Files = [
			"dsp/alpha_processing_sse2.c",
			"dsp/dec_sse2.c",
			"dsp/enc_sse2.c",
			"dsp/lossless_sse2.c",
			"dsp/upsampling_sse2.c",
			"dsp/yuv_sse2.c",
		];

		$this->allDecodeFiles = array_merge($this->baseFiles);
		$this->allEncodeFiles = array_merge($this->baseFiles, $this->encodeFiles);
	}

	public function buildSwc($addEncode) {
		$allFiles = $addEncode ? $this->allEncodeFiles : $this->allDecodeFiles;
		$outputFile = $addEncode ? 'bin/libwebp.swc' : 'bin/libwebp_decode.swc';

		$exportSymbols = [
			"_start1", "malloc", "free", "memcpy", "memmove", "flascc_uiTickProc", "_sync_synchronize",
			"DecodeWebp", "EncodeWebp", "_DecodeWebp", "_EncodeWebp", "WebPEncodeBGRA", "_WebPEncodeBGRA",
			"WebPDecodeBGRA", "_WebPDecodeBGRA", "_Unwind_SjLj_Register", "_Unwind_SjLj_Resume",
			"_Unwind_SjLj_Unregister", "_Unwind_SjLj_RaiseException", "__muldi3", "__udivdi3", "__ashldi3", "__lshrdi3"
		];

		file_put_contents('exports.txt', implode("\n", $exportSymbols));

		$args = [];
		$args[] = '-Werror';
		$args[] = '-Wno-write-strings';
		$args[] = '-Wno-trigraphs';
		$args[] = '-O4';
		foreach ($allFiles as $file) $args[] = __DIR__ . '/libwebp/src/' . trim($file);
		$args[] = 'as3api.c';
		if ($addEncode)  $args[] = 'as3api_encode.c';
		$args[] = '-flto-api=exports.txt';
		$args[] = '-disable-telemetry';
		$args[] = '-no-swf-preloader';
		$args[] = '-emit-swc=libwebp.internal';
		$args[] = "-o{$outputFile}";

		putenv("FLASCC={$this->FLASCC}");
		putenv("FLEX={$this->FLEX}");
		putenv("AS3COMPILERARGS=java -jar {$this->FLASCC}/usr/lib/asc2.jar -merge -md");

		$this->passthru("{$this->FLASCC}/usr/bin/gcc", $args);
	}

	private function passthru($cmd, $args) {
		$command = escapeshellcmd($cmd) . " " . implode(' ', array_map('escapeshellarg', $args));
		echo "$command\n";
		passthru($command);
	}

	public function buildAne() {
		$allFiles = $this->allEncodeFiles;
		putenv("AIRSDK={$this->FLEX}");
		$args = [];
		$args[] = "-I"; $args[] = "{$this->FLEX}/include";
		//$args[] = "-F"; $args[] = "{$this->FLEX}/runtimes/air/mac";
		$args[] = "-framework";
		$args[] = "Adobe AIR";
		$args[] = '-dynamiclib';
		$args[] = '-m32';
		$args[] = '-O3';
		$args[] = '-ffast-math';
		foreach ($allFiles as $file) $args[] = __DIR__ . '/libwebp/src/' . trim($file);
		foreach ($this->sse2Files as $file) $args[] = __DIR__ . '/libwebp/src/' . trim($file);
		$args[] = 'webp_extension.c';
		$args[] = '-oane/mac/libMacOS.framework';

		$this->passthru("gcc", $args);
	}
}

$lib = new BuildLib();
$lib->buildAne();
//$lib->buildSwc(false);
//$lib->buildSwc(true);

/*
build_swc(false);
build_swc(true);
*/
