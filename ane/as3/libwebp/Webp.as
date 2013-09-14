package libwebp
{
	import flash.display.BitmapData;
	import flash.external.ExtensionContext;
	import flash.utils.ByteArray;

	public class Webp
	{
		static private var _context:ExtensionContext = null;
		static private function get context():ExtensionContext
		{
			const contextId:String = 'libwebp.Webp';
			if (_context === null) _context = ExtensionContext.createExtensionContext(contextId, '');
			if (_context === null) throw(new Error("Can't get ExtensionContext: '" + contextId + "'"));
			return _context;
		}
		
		static public function decodeWebp(data:ByteArray):BitmapData
		{
			var info:* = Webp.context.call('WebpDecodeAne', data);
			if (info === null || info.data === null) throw(new Error("Can't decode webp."));
			return info.data;
		}

		static public function getVersion():*
		{
			return Webp.context.call('WebpGetVersionAne');
		}
	}
}