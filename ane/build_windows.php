<?php

$airsdk = "c:\\dev\\airsdk";

$objs = [];
//$flags = '/MT /O2 /D_USRDLL /D_WINDLL';
$flags = '/MT /O2 /D_USRDLL /D_WINDLL /D__SSE2__';
foreach ([
	glob('../libwebp/src/dec/*.c'),
	glob('../libwebp/src/dsp/*.c'),
	glob('../libwebp/src/enc/*.c'),
	glob('../libwebp/src/demux/*.c'),
	glob('../libwebp/src/mux/*.c'),
	glob('../libwebp/src/utils/*.c'),
	['webp_extension.c'],
] as $files) {
	foreach ($files as $file) {
		$obj = "{$file}.obj";
		$objs[] = $obj;
		if (@filemtime($obj) != @filemtime($file)) {
			echo `cl /nologo /c {$flags} /I"{$airsdk}\\include" {$file} /Fo{$obj}`;
		}
		touch($obj, filemtime($file));
	}
}

$objs_string = implode(' ', $objs);
echo `cl /nologo {$flags} {$objs_string} "{$airsdk}\\lib\\win\\FlashRuntimeExtensions.lib" /link /DLL /OUT:windows/libWindows.dll`;
unlink('windows/libWindows.exp');
unlink('windows/libWindows.lib');
//foreach ($objs as $obj) unlink($obj);
