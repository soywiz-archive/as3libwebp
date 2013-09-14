#include <stdio.h>
#include "../libwebp/src/webp/decode.h"
#include <FlashRuntimeExtensions.h>

FREObject DecodeWebpAne(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	FREByteArray input;
	FREObject result;
	FREObject bitmapDataObject;
	FREBitmapData2 bitmapData;
	FREObject thrownException;
	uint8_t* output_pointer;
	int width, height;
	FREObject widthObject, heightObject;
	FREObject callArgv[8];

	if (argc < 1) return NULL;

	{
		FREObjectType _type = FRE_TYPE_NULL;	
		_type = FRE_TYPE_NULL;
		if (FREGetObjectType(argv[0], &_type) != FRE_OK) return NULL;
		if (_type != FRE_TYPE_BYTEARRAY) return NULL;
	}
	
	FREAcquireByteArray(argv[0], &input);
	
	output_pointer = WebPDecodeARGB(
		(const uint8_t*)input.bytes,
		(size_t)input.length,
		&width, &height
	);
	
	FRENewObjectFromUint32(width, &widthObject);
	FRENewObjectFromUint32(height, &heightObject);

	callArgv[0] = widthObject;
	callArgv[1] = heightObject;
	if (FRENewObject("flash.display.BitmapData", 2, callArgv, &bitmapDataObject, &thrownException) != FRE_OK) {
		return NULL;
	}
	
	FREAcquireBitmapData2(bitmapDataObject, &bitmapData);
	{
		memcpy(bitmapData.bits32, output_pointer, width * height * 4);
	}
	FREInvalidateBitmapDataRect(bitmapDataObject, 0, 0, width, height);
	FREReleaseBitmapData(bitmapDataObject);
	
	if (FRENewObject("Object", 0, NULL, &result, &thrownException) != FRE_OK) {
		return NULL;
	}
	FRESetObjectProperty(result, "width", widthObject, &thrownException);
	FRESetObjectProperty(result, "height", heightObject, &thrownException);
	FRESetObjectProperty(result, "data", bitmapDataObject, &thrownException);

	/*
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

	output_pointer = WebPDecodeARGB((const uint8_t*)input_address, (size_t)input_length, &width, &height);
	
	AS3_CopyScalarToVar(width, width);
	AS3_CopyScalarToVar(height, height);
	AS3_CopyScalarToVar(output_pointer, output_pointer);

    inline_as3(
		"var outputByteArray:ByteArray = new ByteArray();\n"
		"CModule.readBytes(output_pointer, width * height * 4, outputByteArray);\n"
		"outputByteArray.position = 0;\n"
        : : 
    );
	
	free(output_pointer);

    inline_as3(
		"var bitmapData:BitmapData = new BitmapData(width, height);\n"
		"bitmapData.setPixels(new Rectangle(0, 0, width, height), outputByteArray);\n"
		"return bitmapData;\n"
        : : 
    );
	*/
	return result;
}

#define FUNC_MAX_COUNT 64

#define FUNC_INIT(functionData) \
	void* globalFuncData = functionData; \
	FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (FUNC_MAX_COUNT));

#define FUNC_ADD(functionRef) \
	func[*numFunctions].name = (const uint8_t*) #functionRef; \
	func[*numFunctions].functionData = globalFuncData; \
	func[*numFunctions].function = &functionRef; \
	*numFunctions++;

void contextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctions, const FRENamedFunction** functions)
{
	FUNC_INIT(NULL);
	FUNC_ADD(DecodeWebpAne);
}

void contextFinalizer(FREContext ctx)
{
	return;
}

__declspec(dllexport) void initializer(void** extData, FREContextInitializer* ctxInitializer, FREContextFinalizer* ctxFinalizer)
{
	*ctxInitializer = &contextInitializer;
	*ctxFinalizer = &contextFinalizer;
}

__declspec(dllexport) void finalizer(void* extData)
{
	return;
}