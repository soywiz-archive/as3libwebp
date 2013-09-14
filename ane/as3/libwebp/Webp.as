package libwebp
{
	import flash.display.BitmapData;
	import flash.external.ExtensionContext;
	import flash.utils.ByteArray;

	public class Webp
	{
		static private var _context:ExtensionContext;
		static private function get context():ExtensionContext
		{
			if (_context === null) _context = ExtensionContext.createExtensionContext('libwebp', '');
			return _context;
		}
		
		static public function decodeWebp(data:ByteArray):BitmapData
		{
			var info:* = context.call('DecodeWebpAne', data);
			return info.data;
		}
	}
}