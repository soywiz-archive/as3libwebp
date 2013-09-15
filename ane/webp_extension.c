//#include <Windows.h>
//BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved) { return TRUE; }

#include <stdio.h>
#include <stdlib.h>
#include "../libwebp/src/webp/decode.h"
#include <FlashRuntimeExtensions.h>

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

	FRENewObjectFromInt32(width, &widthObject);
	FRENewObjectFromInt32(height, &heightObject);

	callArgv[0] = widthObject;
	callArgv[1] = heightObject;
	FRENewObjectFromBool(1, &callArgv[2]);
	FRENewObjectFromUint32((unsigned int)0xFFFFFFFF, &callArgv[3]);

	if ((_result = FRENewObject("flash.display.BitmapData", 4, callArgv, &bitmapDataObject, &thrownException)) != FRE_OK) {
		goto cleanup;
	}
	
	FREAcquireBitmapData2(bitmapDataObject, &bitmapData);
	{
		int y;
		for (y = 0; y < height; y++) {
			memcpy(
				bitmapData.bits32 + bitmapData.lineStride32 * y,
				output_pointer + width * (height - y - 1),
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
	
	if ((_result = FRENewObject("Object", 0, NULL, &result, &thrownException)) != FRE_OK) {
		goto cleanup;
	}
	FRESetObjectProperty(result, "width", widthObject, &thrownException);
	FRESetObjectProperty(result, "height", heightObject, &thrownException);
	FRESetObjectProperty(result, "data", bitmapDataObject, &thrownException);
	
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
