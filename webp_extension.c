//#include <Windows.h>
//BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved) { return TRUE; }

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "libwebp/src/webp/decode.h"
#include "libwebp/src/dsp/dsp.h"
#include "FlashRuntimeExtensions.h"

#define fprintf_file(filename, ...) { FILE *f = fopen(filename, "wb"); fprintf(f, __VA_ARGS__); fclose(f); }

FREObject WebpGetVersionAne(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	FREObject result;
	FRENewObjectFromUint32(1, &result);
	return result;
}

FREObject newInt32(int value) { FREObject result; return (FRENewObjectFromInt32(value, &result) == FRE_OK) ? result : NULL; }
FREObject newUInt32(unsigned int value) { FREObject result; return (FRENewObjectFromUint32(value, &result) == FRE_OK) ? result : NULL; }

double getDouble(FREObject object, double _default) { double value = _default; FREGetObjectAsDouble(object, &value); return value; }

FREObjectType getType(FREObject object) {
	FREObjectType _type = FRE_TYPE_NULL;	
	FREGetObjectType(object, &_type);
	return _type;
}

FREObject WebpEncodeAne(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	FREBitmapData2 input = {0};
	FREByteArray output = {0};
	uint8_t* output_pointer = NULL;
	size_t output_size = 0;
	FREObject result = NULL;
	FREObject temp[4];
	float quality = 50;
	int y, y2;
	int width = input.width;
	int height = input.height;
	int stride = input.lineStride32 * 4;
	uint32_t* from_pointer = (uint32_t*)input.bits32;
	uint32_t* temp_pointer = (uint32_t*)malloc(stride * height);

	if (argc < 2) return NULL;
	
	if (getType(argv[0]) != FRE_TYPE_BITMAPDATA) return NULL;
	quality = (float)getDouble(argv[1], 50);

	FREAcquireBitmapData2(argv[0], &input);
	for (y = 0; y < height; y++) {
		y2 = input.isInvertedY ? (height - y - 1) : y;
		memcpy(temp_pointer + input.lineStride32 * y, from_pointer + width * y2, stride);
	}

	output_size = WebPEncodeBGRA(temp_pointer, width, height, stride, *((int *)&quality), &output_pointer);

	free(temp_pointer);
	FREReleaseBitmapData(argv[0]);
	
	if (output_size == 0) goto cleanup;
	
	FRENewObject("flash.utils.ByteArray", 0, NULL, &result, NULL);
	FRESetObjectProperty(result, "length", newInt32(output_size), NULL);
	
	FREAcquireByteArray(result, &output);
	if (output.length == output_size) memcpy(output.bytes, output_pointer, output_size);
	FREReleaseByteArray(result);
	
cleanup:;
	
	if (output_pointer != NULL) { free(output_pointer); output_pointer = NULL; }
	return result;
}

FREObject WebpDecodeAne(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	FREByteArray input;
	FREObject result;
	FREResult _result;
	FREObject bitmapDataObject;
	FREBitmapData2 bitmapData;
	FREObject thrownException;
	uint32_t* output_pointer = NULL;
	int width, height;
	FREObject widthObject, heightObject;
	FREObject callArgv[8];
	int y, y2;
	FREObjectType _type = FRE_TYPE_NULL;

	if (argc < 1) return NULL;

	_type = FRE_TYPE_NULL;
	if (FREGetObjectType(argv[0], &_type) != FRE_OK) return NULL;
	if (_type != FRE_TYPE_BYTEARRAY) return NULL;

	if ((_result = FREAcquireByteArray(argv[0], &input)) != FRE_OK) goto cleanup;
	output_pointer = (uint32_t *)WebPDecodeBGRA((const uint8_t*)input.bytes, (size_t)input.length, &width, &height);
	if ((_result = FREReleaseByteArray(argv[0])) != FRE_OK) goto cleanup;
	if (output_pointer == NULL) goto cleanup;

	FRENewObjectFromInt32(width, &widthObject);
	FRENewObjectFromInt32(height, &heightObject);

	callArgv[0] = widthObject;
	callArgv[1] = heightObject;
	FRENewObjectFromBool(1, &callArgv[2]);
	FRENewObjectFromUint32((unsigned int)0xFFFFFFFF, &callArgv[3]);

	if ((_result = FRENewObject("flash.display.BitmapData", 4, callArgv, &bitmapDataObject, &thrownException)) != FRE_OK) goto cleanup;

	FREAcquireBitmapData2(bitmapDataObject, &bitmapData);
	for (y = 0; y < height; y++) {
		y2 = bitmapData.isInvertedY ? (height - y - 1) : y;
		memcpy(bitmapData.bits32 + bitmapData.lineStride32 * y, output_pointer + width * y2, bitmapData.lineStride32 * 4);
	}
	FREInvalidateBitmapDataRect(bitmapDataObject, 0, 0, width, height);
	FREReleaseBitmapData(bitmapDataObject);
	
	result = bitmapDataObject;
	
cleanup:;
	if (output_pointer != NULL) { free(output_pointer); output_pointer = NULL; }

	return result;
}

#define FUNC_MAX_COUNT 64

#define FUNC_INIT(functionData) \
	{ \
	void* globalFuncData = functionData; \
	FRENamedFunction* _functions = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (FUNC_MAX_COUNT)); \
	*numFunctions = 0;

#define FUNC_ADD(functionName, functionRef) \
	_functions[*numFunctions].name = (const uint8_t*) functionName; \
	_functions[*numFunctions].functionData = NULL; \
	_functions[*numFunctions].function = &functionRef; \
	(*numFunctions)++;

#define FUNC_ADD2(functionRef) FUNC_ADD(#functionRef, functionRef)
	
#define FUNC_END() \
		*functions = _functions; \
	}

void contextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctions, const FRENamedFunction** functions)
{
	FUNC_INIT(NULL);
	FUNC_ADD2(WebpDecodeAne);
	FUNC_ADD2(WebpEncodeAne);
	FUNC_ADD2(WebpGetVersionAne);
	FUNC_END();
	//fprintf_file("c:/temp/1/contextInitializer", "numFunctions:%d\n", *numFunctions);
}

void contextFinalizer(FREContext ctx)
{
}

#ifdef _WINDLL
#define DLL_EXPORT __declspec(dllexport)
#else
#define DLL_EXPORT 
#endif
DLL_EXPORT void initializer(void** extData, FREContextInitializer* ctxInitializer, FREContextFinalizer* ctxFinalizer)
{
	*ctxInitializer = &contextInitializer;
	*ctxFinalizer = &contextFinalizer;
}

DLL_EXPORT void finalizer(void* extData)
{
}
