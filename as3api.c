#include "libwebp/src/webp/decode.h"
#include <stdlib.h>
#include "AS3/AS3.h"

void DecodeWebp() __attribute__((used,
	annotate("as3import:flash.utils.ByteArray"),
	annotate("as3import:flash.display.BitmapData"),
	annotate("as3import:flash.geom.Rectangle"),
	annotate("as3sig:public function DecodeWebp(inputByteArray:ByteArray):BitmapData"),
	annotate("as3package:libwebp")));

void DecodeWebp()
{
	int input_address;
	int input_length;
	uint8_t* output_pointer;
	int width, height;
	
    inline_as3(
		"var width:int, height:int, output_pointer:int;\n"
		"var input_length:int = inputByteArray.length;\n"
		"var input_address:int = CModule.malloc(input_length);\n"
		"inputByteArray.position = 0;\n"
		"CModule.writeBytes(input_address, input_length, inputByteArray);\n"
		"inputByteArray.position = 0;\n"
        : : 
	);
	
	AS3_GetScalarFromVar(input_address, input_address);
	AS3_GetScalarFromVar(input_length, input_length);

	//output_pointer = WebPDecodeARGB((const uint8_t*)input_address, (size_t)input_length, &width, &height);
	//output_pointer = WebPDecodeRGBA((const uint8_t*)input_address, (size_t)input_length, &width, &height);
	output_pointer = WebPDecodeBGRA((const uint8_t*)input_address, (size_t)input_length, &width, &height);
	
    inline_as3(
		"CModule.free(input_address);\n"
        : : 
	);
	
	if (output_pointer == NULL) {
		inline_as3(
			"return null;\n"
			: : 
		);
	} else {
		AS3_CopyScalarToVar(width, width);
		AS3_CopyScalarToVar(height, height);
		AS3_CopyScalarToVar(output_pointer, output_pointer);

		inline_as3(
			"ram_init.position = output_pointer;\n"
			"var bitmapData:BitmapData = new BitmapData(width, height);\n"
			"bitmapData.setPixels(new Rectangle(0, 0, width, height), ram_init);\n"
			: : 
		);

		/*
		inline_as3(
			"var outputByteArray:ByteArray = new ByteArray();\n"
			"CModule.readBytes(output_pointer, width * height * 4, outputByteArray);\n"
			"outputByteArray.position = 0;\n"
			"var bitmapData:BitmapData = new BitmapData(width, height);\n"
			"bitmapData.setPixels(new Rectangle(0, 0, width, height), outputByteArray);\n"
			: : 
		);
		*/

		free(output_pointer);

		inline_as3(
			"return bitmapData;\n"
			: : 
		);
	}
}

int main() { AS3_GoAsync(); }
