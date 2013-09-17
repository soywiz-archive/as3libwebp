package libwebp
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	public function DecodeWebp(data:ByteArray):BitmapData
	{
		var info:* = context.call('WebpDecodeAne', data);
		if (info === null) return null;
		return info.data;
	}
}

import flash.external.ExtensionContext;
import flash.display.BitmapData;
import flash.utils.ByteArray;

var _context:ExtensionContext = null;
function get context():ExtensionContext
{
	const contextId:String = 'webp';
	if (_context === null) _context = ExtensionContext.createExtensionContext(contextId, '');
	if (_context === null) throw(new Error("Can't get ExtensionContext: '" + contextId + "'"));
	return _context;
}