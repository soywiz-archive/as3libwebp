<?php

class BuildLib {
	private $allDecodeFilesNone;
	private $allEncodeFilesNone;
	private $allEncodeFilesSse2;
	private $FLASCC = '/Developer/crossbridge/sdk';
	private $FLEX = '/Developer/airsdk15';

	public function __construct() {
		$baseFiles = [
			"dec/alpha.c", "dec/buffer.c", "dec/frame.c", "dec/idec.c", "dec/io.c", "dec/quant.c", "dec/tree.c",
			"dec/vp8.c", "dec/vp8l.c", "dec/webp.c", "dsp/cpu.c",
			"dsp/dec_clip_tables.c", "demux/demux.c", "utils/bit_reader.c",
			"utils/color_cache.c", "utils/filters.c", "utils/huffman.c", "utils/rescaler.c", "utils/thread.c",
			"utils/random.c", "utils/utils.c", "utils/quant_levels_dec.c"
		];

		$encodeFiles = [
			"enc/alpha.c", "enc/analysis.c", "enc/backward_references.c", "enc/picture_csp.c", "enc/config.c",
			"enc/cost.c", "enc/filter.c", "enc/frame.c", "enc/histogram.c", "enc/iterator.c", "enc/picture.c", "enc/quant.c",
			"enc/syntax.c", "enc/tree.c", "enc/vp8l.c", "enc/webpenc.c", "enc/token.c", "mux/muxedit.c", "mux/muxinternal.c",
			"mux/muxread.c", "utils/bit_writer.c", "utils/huffman_encode.c", "utils/quant_levels.c",
		];

		$noneFiles = [
			"dsp/alpha_processing.c",
			"dsp/dec.c",
			"dsp/lossless.c",
			"dsp/upsampling.c",
			"dsp/yuv.c",
		];

		$noneFilesEncode = [
			"dsp/enc.c",
		];

		$sse2Files = [
			"dsp/alpha_processing_sse2.c",
			"dsp/dec_sse2.c",
			"dsp/lossless_sse2.c",
			"dsp/upsampling_sse2.c",
			"dsp/yuv_sse2.c",
		];

		$sse2FilesEncode = [
			"dsp/enc_sse2.c",
		];

		$this->allDecodeFilesNone = array_merge($baseFiles, $noneFiles);
		$this->allEncodeFilesNone = array_merge($baseFiles, $noneFiles, $noneFilesEncode, $encodeFiles);
		$this->allEncodeFilesSse2 = array_merge($baseFiles, $encodeFiles, $noneFiles, $noneFilesEncode, $sse2Files, $sse2FilesEncode);
	}

	public function buildSwc($addEncode) {
		$allFiles = $addEncode ? $this->allEncodeFilesNone : $this->allDecodeFilesNone;
		$outputFile = $addEncode ? 'bin/libwebp.swc' : 'bin/libwebp_decode.swc';
		$exportsTxt = 'exports.txt';

		$exportSymbols = [
			"_start1", "malloc", "free", "memcpy", "memmove", "flascc_uiTickProc", "_sync_synchronize",
			"DecodeWebp", "EncodeWebp", "_DecodeWebp", "_EncodeWebp", "WebPEncodeBGRA", "_WebPEncodeBGRA",
			"WebPDecodeBGRA", "_WebPDecodeBGRA", "_Unwind_SjLj_Register", "_Unwind_SjLj_Resume",
			"_Unwind_SjLj_Unregister", "_Unwind_SjLj_RaiseException", "__muldi3", "__udivdi3", "__ashldi3",
			"__lshrdi3", "__floatundidf"
		];

		file_put_contents($exportsTxt, implode("\n", $exportSymbols));

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

		unlink($exportsTxt);
	}

	private function passthru($cmd, $args) {
		$command = escapeshellcmd($cmd) . " " . implode(' ', array_map('escapeshellarg', $args));
		echo "$command\n";
		passthru($command);
	}

	public function buildAne() {
		$this->buildAneAndroid();
		$this->buildAneWindows();
		$this->buildAneMac();
		$targets = [
			//['Android-ARM', 'android'],
			['Windows-x86', 'windows'],
			['MacOS-x86', 'mac'],
			['default', 'default']
		];
		$this->passthru("{$this->FLEX}/bin/acompc", [
			"-source-path", "ane/as3",
			"-include-sources", "ane/as3",
			"-optimize",
			"-swf-version", "13",
			"-output", "ane/libwebp_ane.swc",
		]);
		$anelibrary = file_get_contents('zip://ane/libwebp_ane.swc#library.swf');
		foreach ($targets as $target) {
			list($name, $folder) = $target;
			file_put_contents("ane/{$folder}/library.swf", $anelibrary);
		}
		$args = [];
		$args[] = '-package';
		$args[] = '-target';
		$args[] = 'ane';
		$args[] = 'bin/libwebp.ane';
		$args[] = 'ane/extension.xml';
		$args[] = '-swc';
		$args[] = 'ane/libwebp_ane.swc';
		foreach ($targets as $target) {
			list($name, $folder) = $target;
			$args[] = '-platform';
			$args[] = $name;
			$args[] = '-C';
			$args[] = "ane/{$folder}";
			$args[] = '.';
		}
		$this->passthru("{$this->FLEX}/bin/adt", $args);
		/*
		#!/bin/bash
		-platform Android-ARM -C android . \
		-platform Windows-x86 -C windows . \
		-platform MacOS-x86 -C mac . \
		-platform default -C default .
		rm libwebp_ane.swc
		*/
	}

	public function buildAneAndroid() {
		$out = '
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE    := prebuild-FlashRuntimeExtensions
LOCAL_SRC_FILES := external/lib/FlashRuntimeExtensions.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE    := webp_extension
APP_ABI := armeabi-v7a
#APP_ABI := armeabi armeabi-v7a x86 mips
ARCH := $(APP_ABI)
APP_OPTIM := release
LOCAL_CFLAGS=-ffast-math -O3
LOCAL_CFLAGS += -DNDEBUG
LOCAL_SRC_FILES := ###FILES###
LOCAL_SHARED_LIBRARIES := prebuild-FlashRuntimeExtensions
LOCAL_C_INCLUDES       := external/include
include $(BUILD_SHARED_LIBRARY)
		';
		$out = strtr($out, [
			'###FILES###' => implode(' ', array_map(function($file) {
				return getRelativePath(__DIR__ . '/ane/jni', __DIR__ . '/libwebp/src/' . trim($file));
			}, $this->allEncodeFilesNone))
		]);
		file_put_contents('ane/jni/Android.mk', trim($out));
	}

	public function buildAneWindows() {
		$outputFile = 'ane/windows/libWindows.dll';
		$allFiles = $this->allEncodeFilesSse2;
		//$allFiles = $this->allEncodeFilesNone;
		putenv("AIRSDK={$this->FLEX}");
		$flags = ['/nologo', '/MT', '/O2', '/D_USRDLL', '/D_WINDLL', '/D__SSE2__'];
		$objs = [];
		foreach ($allFiles as $file) {
			$args = array_merge(['cl', '/c'], $flags, []);
			$sourceFile = getRelativePath(__DIR__, __DIR__ . '/libwebp/src/' . trim($file));
			$obj = str_replace('.c.obj', '.obj', "{$sourceFile}.obj");
			$objs[] = $obj;
			$args[] = $sourceFile;
			$args[] = "/Fo{$obj}";
			$this->passthru("wine", $args);
			//$args[] = getRelativePath(__DIR__, __DIR__ . '/libwebp/src/' . trim($file));
		}

		$args = array_merge(['cl'], $flags, $objs);
		$args[] = 'ane/libs/win/FlashRuntimeExtensions.lib';
		$args[] = '/link';
		$args[] = '/DLL';
		$args[] = "/OUT:{$outputFile}";

		@mkdir(dirname($outputFile), 0777, true);
		$this->passthru("wine", $args);
	}

	public function buildAneMac() {
		$outputFile = 'ane/mac/libMacOS.framework/libMacOS';
		putenv("AIRSDK={$this->FLEX}");
		$args = [];
		$args[] = "-I"; $args[] = "{$this->FLEX}/include";
		$args[] = '-dynamiclib';
		$args[] = "-o";
		$args[] = "{$outputFile}";
		$args[] = "-F"; $args[] = "{$this->FLEX}/runtimes/air/mac";
		$args[] = "-framework";
		$args[] = "Adobe AIR";
		$args[] = '-m32';
		$args[] = '-O3';
		$args[] = '-ffast-math';
		foreach ($this->allEncodeFilesSse2 as $file) $args[] = __DIR__ . '/libwebp/src/' . trim($file);
		$args[] = 'webp_extension.c';

		@mkdir(dirname($outputFile), 0777, true);
		$this->passthru("gcc", $args);
	}
}

function getRelativePath($from, $to)
{
	// some compatibility fixes for Windows paths
	$from = is_dir($from) ? rtrim($from, '\/') . '/' : $from;
	$to   = is_dir($to)   ? rtrim($to, '\/') . '/'   : $to;
	$from = str_replace('\\', '/', $from);
	$to   = str_replace('\\', '/', $to);

	$from     = explode('/', $from);
	$to       = explode('/', $to);
	$relPath  = $to;

	foreach($from as $depth => $dir) {
		// find first non-matching dir
		if($dir === $to[$depth]) {
			// ignore this directory
			array_shift($relPath);
		} else {
			// get number of remaining dirs to $from
			$remaining = count($from) - $depth;
			if($remaining > 1) {
				// add traversals up to first matching dir
				$padLength = (count($relPath) + $remaining - 1) * -1;
				$relPath = array_pad($relPath, $padLength, '..');
				break;
			} else {
				$relPath[0] = './' . $relPath[0];
			}
		}
	}
	return implode('/', $relPath);
}

$lib = new BuildLib();
$lib->buildAne();
//$lib->buildAneWindows();
$lib->buildSwc(false);
$lib->buildSwc(true);
