package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

	import libwebp.DecodeWebp;

	public class Main extends Sprite
	{
		public function Main()
		{
			setTimeout(main, 0);
		}

		[Embed(source="test.webp", mimeType = "application/octet-stream")]
		public var test_webp:Class;

		[Embed(source="texture.webp", mimeType = "application/octet-stream")]
		public var texture_webp:Class;

		/*
		static public function DecodeWebp(inputByteArray:ByteArray):BitmapData
		{
			var inputPointer:int = CModule.malloc(inputByteArray.length);
			CModule.writeBytes(inputPointer, inputByteArray.length, inputByteArray);
			var outputInfo:Object = _DecodeWebp(inputPointer, inputByteArray.length);
			var width:int = outputInfo.width;
			var height:int = outputInfo.height;
			var outputPointer:int = outputInfo.output;
			var outputByteArray:ByteArray = new ByteArray();
			CModule.readBytes(outputPointer, width * height * 4, outputByteArray);
			outputByteArray.position = 0;

			var bitmapData:BitmapData = new BitmapData(width, height);
			bitmapData.setPixels(new Rectangle(0, 0, width, height), outputByteArray);
			return bitmapData;
		}
		*/

		function main():void
		{
			var byteArray1:ByteArray = new test_webp();
			var byteArray2:ByteArray = new texture_webp();

			DecodeWebp(byteArray1);
			DecodeWebp(byteArray2);
			byteArray1.position = 0;
			byteArray2.position = 0;

			var p0:Number = new Date().getTime();
			var bitmap1:Bitmap = new Bitmap(DecodeWebp(byteArray1));
			var p1:Number = new Date().getTime();
			var bitmap2:Bitmap = new Bitmap(DecodeWebp(byteArray2));
			var p2:Number = new Date().getTime();
			var textField:TextField = new TextField();
			textField.defaultTextFormat = new TextFormat("Arial", 20, 0x000000);
			textField.width = 1000;
			textField.text = "Time1: " + (p1 - p0) + ' : ' + "Time2: " + (p2 - p1);
			bitmap2.x = 100;
			bitmap2.y = 100;
			addChild(bitmap1);
			addChild(bitmap2);
			addChild(textField);
		}
	}
}
