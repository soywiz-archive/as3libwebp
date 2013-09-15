package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

	import libwebp.DecodeWebp;

	[SWF(width = 500, height = 320, frameRate = 60)]
	public class MainFileSelector extends Sprite
	{
		public function MainFileSelector()
		{
			setTimeout(main, 0);
		}

		private var imageContainer:Sprite;

		private var fileRef:FileReference;

		[Embed(source="test3.webp", mimeType = "application/octet-stream")]
		public var test3WebpByteArrayClass:Class;

		private var timeTextField:TextField;

		private function main():void
		{
			MouseWheel.capture();
			addChild(imageContainer = new Sprite());
			var buttonShape:Sprite = new Sprite();
			buttonShape.graphics.lineStyle(2, 0xFFFFFF, 0.3);
			buttonShape.graphics.beginFill(0x000000, 0.3);
			buttonShape.graphics.drawRect(0, 0, 320, 32);
			buttonShape.graphics.endFill();

			timeTextField = new TextField();
			timeTextField.defaultTextFormat = new TextFormat('Arial', 14, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.RIGHT);
			timeTextField.background = true;
			timeTextField.backgroundColor = 0x000000;
			timeTextField.autoSize = TextFieldAutoSize.RIGHT;
			timeTextField.x = stage.stageWidth - 4;
			timeTextField.y = stage.stageHeight - 16 - 4;
			addChild(timeTextField);


			var tf:TextField = new TextField();
			tf.defaultTextFormat = new TextFormat('Arial', 14, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER)
			tf.text = "Select webp image...";
			tf.width = 320;
			tf.height = 32;
			tf.y = 6;
			buttonShape.addChild(tf);
			//buttonShape.graphics.drawRect(0, 0, 320, 32);
			var button = new SimpleButton(buttonShape, buttonShape, buttonShape, buttonShape);
			addChild(button);

			DecodeWebp(new test3WebpByteArrayClass());
			setImageFromWebpByteArray(new test3WebpByteArrayClass());

			fileRef = new FileReference();
			button.addEventListener(MouseEvent.CLICK, onButtonClick);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
		}

		private function onButtonClick(e:MouseEvent):void
		{
			fileRef.browse([new FileFilter("Webp Images (*.webp)", "*.webp")]);
			fileRef.addEventListener(Event.SELECT, onFileSelected);
		}

		private function onFileSelected(e:Event):void
		{
			fileRef.addEventListener(Event.COMPLETE, onFileLoaded);
			fileRef.load();
		}

		var image:MovieClip;

		private function onFileLoaded(e:Event):void
		{
			setImageFromWebpByteArray(e.target.data);
		}

		private function setImageFromWebpByteArray(byteArray:ByteArray):void
		{
			if (image != null)
			{
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, pickMe);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveMe);
				stage.removeEventListener(MouseEvent.MOUSE_UP, dropMe);
			}

			imageContainer.removeChildren();
			image = new MovieClip();
			var startTime:Number = new Date().getTime();
			var bitmapData:BitmapData = DecodeWebp(byteArray);
			var endTime:Number = new Date().getTime();
			//trace(endTime - startTime);
			timeTextField.text = 'Webp image loaded in ' + (endTime - startTime) + 'ms';
			var bmp:Bitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, true);
			bmp.x = -bmp.width / 2;
			bmp.y = -bmp.height / 2;
			image.addChild(bmp);
			image.x = stage.stageWidth / 2;
			image.y = stage.stageHeight / 2;
			imageContainer.addChild(image);

			stage.addEventListener(MouseEvent.MOUSE_DOWN, pickMe);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveMe);
			stage.addEventListener(MouseEvent.MOUSE_UP, dropMe);

			imageScale = 1;
			updateScale();
		}

		private function updateScale():void
		{
			if (image != null) {
				image.scaleX = this.imageScale;
				image.scaleY = this.imageScale;
			}
		}

		private var moveMouseStart:Point;
		private var moveImageStart:Point;

		private function pickMe(event:MouseEvent):void
		{
			moveMouseStart = new Point(event.stageX, event.stageY);
			moveImageStart = new Point(image.x, image.y);
		}

		private function moveMe(event:MouseEvent):void
		{
			if (moveMouseStart == null) return;
			var moveMouseCurrent:Point = new Point(event.stageX, event.stageY);
			var increment:Point = moveMouseCurrent.subtract(moveMouseStart);
			var moveImageCurrent:Point = moveImageStart.add(increment);
			image.x = moveImageCurrent.x;
			image.y = moveImageCurrent.y;
		}

		private function dropMe(event:MouseEvent):void
		{
			moveMouseStart = null;
			//image.stopDrag();
		}

		var imageScale:Number = 1.0;

		private function mouseWheelHandler(event:MouseEvent):void
		{
			//trace(event.delta);
			var scaleMultiplier:Number = 1.1;
			if (event.delta < 0) scaleMultiplier = 1 / scaleMultiplier;
			this.imageScale *= scaleMultiplier;
			updateScale();
		}
	}
}

