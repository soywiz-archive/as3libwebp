#include "../libwebp/src/webp/decode.h"
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

typedef struct
{
	uint8_t B, G, R, A;
} BGRA;

void EncodeWebp() __attribute__((used,
	annotate("as3import:flash.utils.ByteArray"),
	annotate("as3import:flash.utils.Endian"),
	annotate("as3import:flash.display.BitmapData"),
	annotate("as3import:flash.geom.Rectangle"),
	annotate("as3sig:public function EncodeWebp(inputBitmapData:BitmapData, quality_factor:Number):ByteArray"),
	annotate("as3package:libwebp")));

void EncodeWebp()
{
	size_t output_size;
	uint8_t* input_address;
	BGRA* pointer;
	BGRA* pointer_end;
	uint8_t* output_pointer;
	int width;
	int height;
	double quality_factor;
	BGRA v, v2;
	int size;
	int n;
	
    inline_as3(
		"var output_pointer:int, output_size:int;\n"
		"var width:int = inputBitmapData.width;\n"
		"var height:int = inputBitmapData.height;\n"
		"var input_length:int = width * height * 4;\n"
		"var input_address:int = CModule.malloc(input_length);\n"
		"var inputByteArray:ByteArray = inputBitmapData.getPixels(new Rectangle(0, 0, width, height));\n"
		"inputByteArray.endian = Endian.LITTLE_ENDIAN;\n"
		"inputByteArray.position = 0;\n"
		"CModule.writeBytes(input_address, input_length, inputByteArray);\n"
		"inputByteArray.position = 0;\n"
        : : 
	);
	
	AS3_GetScalarFromVar(input_address, input_address);
	AS3_GetScalarFromVar(width, width);
	AS3_GetScalarFromVar(height, height);
	AS3_GetScalarFromVar(quality_factor, quality_factor);
	
	pointer = (BGRA *)input_address;
	pointer_end = pointer + (width * height);
	for (; pointer < pointer_end; pointer++) {
		v = *pointer;
		v2.B = v.A;
		v2.G = v.R;
		v2.R = v.G;
		v2.A = v.B;
		*pointer = v2;
	}
	
	output_size = WebPEncodeBGRA(input_address, width, height, width * 4, (float)quality_factor, &output_pointer);
	//output_size = WebPEncodeARGB(input_address, width, height, width * 4, (float)quality_factor, &output_pointer);
	
	free(input_address);
	
	if (output_size == 0) {
		inline_as3(
			"return null;\n"
			: : 
		);
	} else {
		AS3_CopyScalarToVar(output_pointer, output_pointer);
		AS3_CopyScalarToVar(output_size, output_size);

		inline_as3(
			"var outputByteArray:ByteArray = new ByteArray();\n"
			"outputByteArray.endian = Endian.LITTLE_ENDIAN;\n"
			"CModule.readBytes(output_pointer, output_size, outputByteArray);\n"
			"outputByteArray.position = 0;\n"
			: : 
		);
		
		free(output_pointer);

		inline_as3(
			"return outputByteArray;\n"
			: : 
		);
	}
}

int main() { AS3_GoAsync(); }
