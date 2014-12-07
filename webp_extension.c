//#include <Windows.h>
//BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved) { return TRUE; }

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "libwebp/src/webp/decode.h"
#include "libwebp/src/dsp/dsp.h"
#include "FlashRuntimeExtensions.h"

#define fprintf_file(filename, ...) { FILE *f = fopen(filename, "wb"); fprintf(f, __VA_ARGS__); fclose(f); }

/*
FREObject WebpGetVersionAne(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	fclose(fopen("c:/temp/1/WebpGetVersionAne", "wb"));
	return NULL;
}
*/

FREObject WebpGetVersionAne(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	FREObject result;
	FRENewObjectFromUint32(1, &result);
	
	//fprintf_file("c:/temp/1/WebpGetVersionAne", "YAY!");
	
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
	FREBitmapData input = {0};
	FREByteArray output = {0};
	uint8_t* output_pointer = NULL;
	size_t output_size = 0;
	FREObject result = NULL;
	FREObject temp[4];
	float quality = 50;

	if (argc < 2) return NULL;
	
	if (getType(argv[0]) != FRE_TYPE_BITMAPDATA) return NULL;
	quality = (float)getDouble(argv[1], 50);

	FREAcquireBitmapData(argv[0], &input);
	{
		//fprintf_file("c:/temp/WebPEncodeBGRA", "%d:: %08X, %d, %d, %d, %f", WebPGetEncoderVersion(), input.bits32, input.width, input.height, input.width * 4, (float)quality);
		
		//VP8GetCPUInfo = NULL;
		//output_size = WebPEncodeBGRA(input.bits32, input.width, input.height, input.width * 4, quality, &output_pointer);
		
		int y, y2;
		int width = input.width;
		int height = input.height;
		int stride = input.lineStride32 * 4;
		uint32_t* from_pointer = (uint32_t*)input.bits32;
		uint32_t* temp_pointer = (uint32_t*)malloc(stride * height);
		
		for (y = 0; y < height; y++) {
			#ifdef __ANDROID__
				y2 = y;
			#else
				y2 = (height - y - 1);
			#endif
			memcpy(
				temp_pointer + input.lineStride32 * y,
				from_pointer + width * y2,
				//output_pointer + width * y,
				stride
			);
		}

		output_size = WebPEncodeBGRA(temp_pointer, width, height, stride, *((int *)&quality), &output_pointer);
		
		free(temp_pointer);
		
		//output_pointer = malloc(output_size = 1024); memset(output_pointer, 0xFF, output_size);
	}
	FREReleaseBitmapData(argv[0]);
	
	if (output_size == 0) goto cleanup;
	
	FRENewObject("flash.utils.ByteArray", 0, NULL, &result, NULL);
	FRESetObjectProperty(result, "length", newInt32(output_size), NULL);
	
	FREAcquireByteArray(result, &output);
	{
		if (output.length == output_size) {
			memcpy(output.bytes, output_pointer, output_size);
		} else {
		}
	}
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
	FREBitmapData bitmapData;
	FREObject thrownException;
	uint32_t* output_pointer = NULL;
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
	
	if ((_result = FREAcquireByteArray(argv[0], &input)) != FRE_OK) {
		goto cleanup;
	}
	{
		//output_pointer = (uint32_t *)WebPDecodeARGB(
		//output_pointer = (uint32_t *)WebPDecodeRGBA(
		output_pointer = (uint32_t *)WebPDecodeBGRA(
			(const uint8_t*)input.bytes,
			(size_t)input.length,
			&width, &height
		);
	}
	if ((_result = FREReleaseByteArray(argv[0])) != FRE_OK) {
		goto cleanup;
	}
	
	if (output_pointer == NULL) {
		return NULL;
	}

	FRENewObjectFromInt32(width, &widthObject);
	FRENewObjectFromInt32(height, &heightObject);

	callArgv[0] = widthObject;
	callArgv[1] = heightObject;
	FRENewObjectFromBool(1, &callArgv[2]);
	FRENewObjectFromUint32((unsigned int)0xFFFFFFFF, &callArgv[3]);

	if ((_result = FRENewObject("flash.display.BitmapData", 4, callArgv, &bitmapDataObject, &thrownException)) != FRE_OK) {
		goto cleanup;
	}
	
	FREAcquireBitmapData(bitmapDataObject, &bitmapData);
	{
		int y, y2;
		for (y = 0; y < height; y++) {
			#ifdef __ANDROID__
				y2 = y;
			#else
				y2 = (height - y - 1);
			#endif
			memcpy(
				bitmapData.bits32 + bitmapData.lineStride32 * y,
				output_pointer + width * y2,
				//output_pointer + width * y,
				bitmapData.lineStride32 * 4
			);
		}
		//lineStride32
		//memcpy(bitmapData.bits32, output_pointer, width * height * 4);
		//bitmapData.hasAlpha = 1;
		//bitmapData.isInvertedY = 0;
		//bitmapData.isPremultiplied = 0;
	}
	FREInvalidateBitmapDataRect(bitmapDataObject, 0, 0, width, height);
	FREReleaseBitmapData(bitmapDataObject);
	
	result = bitmapDataObject;
	
	/*
	if ((_result = FRENewObject("Object", 0, NULL, &result, &thrownException)) != FRE_OK) {
		goto cleanup;
	}
	FRESetObjectProperty(result, "width", widthObject, &thrownException);
	FRESetObjectProperty(result, "height", heightObject, &thrownException);
	FRESetObjectProperty(result, "data", bitmapDataObject, &thrownException);
	*/
	
	//fprintf_file("c:/temp/1/WebpDecodeAne.5", "YAY!");

cleanup:;
	if (output_pointer != NULL) { free(output_pointer); output_pointer = NULL; }
	
	//fprintf_file("c:/temp/1/WebpDecodeAne.cleanup", "YAY!");
	
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
