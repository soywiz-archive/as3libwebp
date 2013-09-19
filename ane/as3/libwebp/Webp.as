package libwebp
{
	import flash.external.ExtensionContext;

	internal class Webp
	{
		static internal var _context:ExtensionContext = null;
		static internal function get context():ExtensionContext
		{
			const contextId:String = 'webp';
			if (_context === null) _context = ExtensionContext.createExtensionContext(contextId, '');
			if (_context === null) throw(new Error("Can't get ExtensionContext: '" + contextId + "'"));
			return _context;
		}
	}
}