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
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

	import libwebp.DecodeWebp;
	import libwebp.EncodeWebp;

	[SWF(width = 1280, height = 720, frameRate = 60)]
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

		private function createButton(text:String):Array
		{
			var width:int = 180;
			var height:int = 32;
			var buttonShape:Sprite = new Sprite();
			buttonShape.graphics.lineStyle(2, 0xFFFFFF, 0.3);
			buttonShape.graphics.beginFill(0x000000, 0.3);
			buttonShape.graphics.drawRect(0, 0, width, height);
			buttonShape.graphics.endFill();

			var tf:TextField = new TextField();
			tf.defaultTextFormat = new TextFormat('Arial', 14, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER)
			tf.selectable = false;
			tf.text = text;
			tf.width = width;
			tf.height = height;
			tf.y = 6;
			buttonShape.addChild(tf);
			//buttonShape.graphics.drawRect(0, 0, 320, 32);
			return [
				new SimpleButton(buttonShape, buttonShape, buttonShape, buttonShape),
				tf
			];
		}

		private function main():void
		{
			//trace('isEvalAvailable: ' + isEvalAvailable());
			//eval("window.addEventListener('mousewheel', function(e) { e.preventDefault(); });");
			//eval("alert(v);", {v : 'HELLO WORLD!'});

			if (ExternalInterface.available) MouseWheel.capture();

			addChild(imageContainer = new Sprite());

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			stage.addEventListener(Event.RESIZE, stage_resizeHandler);

			timeTextField = new TextField();
			stage_resizeHandler(null);

			addChild(timeTextField);


			DecodeWebp(new test3WebpByteArrayClass());
			setImageFromWebpByteArray(new test3WebpByteArrayClass());

			fileRef = new FileReference();
			var button:SimpleButton = createButton("Open image/webp...")[0];
			addChild(button);
			button.addEventListener(MouseEvent.CLICK, onOpen);

			var button2_t:Array = createButton("Save webp (q=" + encodingQuality + ")...");
			var button2:SimpleButton = button2_t[0];
			var button2_text:TextField = button2_t[1];
			button2.x += button.width;
			addChild(button2);
			button2.addEventListener(MouseEvent.CLICK, onSave);

			var editTextField:TextField = new TextField();
			editTextField.defaultTextFormat = new TextFormat('Arial', 24, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
			editTextField.selectable = true;
			editTextField.type = TextFieldType.INPUT;
			editTextField.width = 50;
			editTextField.height = 32;
			editTextField.x = button.width + button2.width;
			editTextField.y = 0;
			editTextField.text = String(encodingQuality);
			editTextField.background = true;
			editTextField.backgroundColor = 0x777777;
			editTextField.addEventListener(Event.CHANGE, function():void {
				encodingQuality = parseFloat(editTextField.text);
				if (encodingQuality < 0) encodingQuality = 0;
				if (encodingQuality > 100) encodingQuality = 100;
				if (isNaN(encodingQuality)) encodingQuality = 50;
				button2_text.text = "Save webp (q=" + encodingQuality + ")...";
			});
			editTextField.addEventListener(FocusEvent.FOCUS_OUT, function():void {
				editTextField.text = String(encodingQuality);
			});
			addChild(editTextField);

			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
		}

		private var encodingQuality:Number = 50;

		private function onSave(e:MouseEvent):void
		{
			var fileRef:FileReference = new FileReference();
			var startTime:Number = new Date().getTime();
			var byteArray:ByteArray = libwebp.EncodeWebp(bitmapData, encodingQuality);
			var endTime:Number = new Date().getTime();
			if (byteArray == null) {
				timeTextField.text = "Couldn't encode Webp image";
				stage_resizeHandler(null);
			} else {
				timeTextField.text = 'Image with size (' + bitmapData.width + 'x' + bitmapData.height + ') encoded with size ' + (int((byteArray.length / 1024)*100)/100) + 'kb in ' + (endTime - startTime) + 'ms';
				stage_resizeHandler(null);
				fileRef.save(byteArray, 'output.webp');
			}
		}

		private function onOpen(e:MouseEvent):void
		{
			fileRef.browse([new FileFilter("Images (*.webp;*.jpg;*.png)", "*.webp;*.jpg;*.png")]);
			fileRef.addEventListener(Event.SELECT, onFileSelected);
		}

		private function onFileSelected(e:Event):void
		{
			fileRef.addEventListener(Event.COMPLETE, onFileLoaded);
			fileRef.load();
		}

		private var image:MovieClip;

		private function onFileLoaded(e:Event):void
		{
			var byteArray:ByteArray = e.target.data;
			var magic:String = byteArray.readUTFBytes(4);
			byteArray.position = 0;

			if (magic == 'RIFF') {
				setImageFromWebpByteArray(byteArray);
			} else {
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void {
					setImageFromBitmapData(byteArray, Bitmap(loader.content).bitmapData);
				});
				loader.loadBytes(byteArray)
			}
		}

		private var bitmapData:BitmapData;

		private function setImageFromBitmapData(byteArray:ByteArray, bitmapData:BitmapData):void
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
			bitmapData.getPixel(0, 0);
			this.bitmapData = bitmapData;
			var endTime:Number = new Date().getTime();
			//trace(endTime - startTime);
			if (bitmapData == null) {
				timeTextField.text = 'Invalid image';
			} else {
				timeTextField.text = 'Image with size (' + bitmapData.width + 'x' + bitmapData.height + ') ' + (int((byteArray.length / 1024)*100)/100) + 'kb loaded in ' + (endTime - startTime) + 'ms';
			}
			stage_resizeHandler(null);
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
			bitmapData = DecodeWebp(byteArray);
			var endTime:Number = new Date().getTime();
			//trace(endTime - startTime);
			if (bitmapData == null) {
				timeTextField.text = 'Invalid Webp image';
			} else {
				timeTextField.text = 'Webp image with size (' + bitmapData.width + 'x' + bitmapData.height + ') ' + (int((byteArray.length / 1024)*100)/100) + 'kb loaded in ' + (endTime - startTime) + 'ms';
			}
			stage_resizeHandler(null);
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

		private var imageScale:Number = 1.0;

		private function mouseWheelHandler(event:MouseEvent):void
		{
			//trace(event.delta);
			var scaleMultiplier:Number = 1.1;
			if (event.delta < 0) scaleMultiplier = 1 / scaleMultiplier;
			this.imageScale *= scaleMultiplier;
			updateScale();
		}

		private function stage_resizeHandler(event:Event):void
		{
			timeTextField.defaultTextFormat = new TextFormat('Arial', 14, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.LEFT);
			timeTextField.background = true;
			timeTextField.backgroundColor = 0x000000;
			timeTextField.text = timeTextField.text;
			timeTextField.autoSize = TextFieldAutoSize.LEFT;
			timeTextField.selectable = false;
			timeTextField.x = stage.stageWidth - 4 - timeTextField.textWidth;
			timeTextField.y = stage.stageHeight - 16 - 4;
			setTimeout(function():void {
				timeTextField.x = stage.stageWidth - 4 - timeTextField.textWidth;
				timeTextField.y = stage.stageHeight - 16 - 4;
			}, 0);
			//timeTextField.autoSize = TextFieldAutoSize.RIGHT;
		}
	}
}


