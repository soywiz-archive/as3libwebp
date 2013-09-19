package libwebp
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	public function DecodeWebp(data:ByteArray):BitmapData
	{
		return BitmapData(Webp.context.call('WebpDecodeAne', data));
	}
}

