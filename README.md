as3libwebp
==========

Load and save WEBP images on Flash using FlashCC or faster ANEs

### Sample

http://soywiz.github.io/as3libwebp/

[![ScreenShot](http://soywiz.github.io/as3libwebp/sample.jpg)](http://soywiz.github.io/as3libwebp/)

### API

```as3
package libwebp;
function DecodeWebp(webpByteArray:ByteArray):BitmapData;
function EncodeWebp(input:BitmapData, quality:Number):ByteArray;
```

SWC supported on all platforms including web. It uses FlashCC so it is portable but runs ~3x-5x times slower:
* You must include bin/libwebp.swc

ANE supported for AIR Windows and Android. It uses native libraries so it will run as fast as possible:
* You must include bin/libwebp.ane

