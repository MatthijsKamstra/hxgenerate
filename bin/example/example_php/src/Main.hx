package ;

import haxe.web.Dispatch;
import haxe.web.Dispatch.DispatchError;

#if neko
	import neko.Web;
#elseif php
	import php.Web;
#end

/**
 * @author Matthijs Kamstra aka[mck]
 * MIT
 * 
 */
class Main
{
    function new()
    {
		// trace("Example PHP");

		try {
			var _webURI = Web.getURI();
			Dispatch.run(_webURI, Web.getParams(), new Routes() );
		} catch (e:DispatchError) {
			Dispatch.run("/", Web.getParams(), new Routes() );
		}
	}

	public static function main()
	{
		var main = new Main();
	}
}

