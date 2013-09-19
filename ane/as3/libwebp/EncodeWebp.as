package libwebp
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	public function EncodeWebp(input:BitmapData, quality:Number):ByteArray
	{
		return ByteArray(Webp.context.call('WebpEncodeAne', input, quality));
	}
}
