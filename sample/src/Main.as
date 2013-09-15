package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

	import libwebp.DecodeWebp;

	[SWF(width = 1280, height = 720, frameRate = 60)]
	public class Main extends Sprite
	{
		[Embed(source="test.webp", mimeType = "application/octet-stream")]
		public var test_webp:Class;

		[Embed(source="texture.webp", mimeType = "application/octet-stream")]
		public var texture_webp:Class;

		[Embed(source="test3.webp", mimeType = "application/octet-stream")]
		public var test3:Class;

		public function Main()
		{
			setTimeout(main, 0);
		}

		function main():void
		{
			var byteArray1:ByteArray = new test_webp();
			//var byteArray2:ByteArray = new texture_webp();
			var byteArray2:ByteArray = new test3();

			DecodeWebp(byteArray1);
			DecodeWebp(byteArray2);

			var p0:Number = new Date().getTime();
			var bitmap1:Bitmap = new Bitmap(DecodeWebp(byteArray1), PixelSnapping.AUTO, true);
			var p1:Number = new Date().getTime();
			var bitmap2:Bitmap = new Bitmap(DecodeWebp(byteArray2), PixelSnapping.AUTO, true);
			var p2:Number = new Date().getTime();
			var textField:TextField = new TextField();
			textField.defaultTextFormat = new TextFormat("Arial", 20, 0x000000);
			textField.width = 1000;
			textField.text = "Time1: " + (p1 - p0) + ' : ' + "Time2: " + (p2 - p1);
			bitmap2.x = 64;
			bitmap2.y = 64;
			addChild(bitmap1);
			addChild(bitmap2);
			addChild(textField);
		}
	}
}
