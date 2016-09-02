package ;

import haxe.web.Dispatch;
import haxe.web.Dispatch.DispatchError;

#if neko
	import neko.Web;
#elseif php
	import php.Web; 
#end 


/**
 * @author Matthijs Kamstra  aka [mck]
 */
class Main
{
    function new()
    {
		// trace("Hello World");		

		try {
			var _webURI = Web.getURI();
			Dispatch.run(_webURI, Web.getParams(), new Routes() );

			// utils.Output.saveX( "test.txt" , _webURI , 'log/' );

		} catch (e:DispatchError) {
			// trace("ERROR: " + e);
			// Output.saveX( "Index_dispatchError_"+Date.now().toString()+".txt" , Std.string(e) , AppConstants.ERROR_FOLDER );
			Dispatch.run("/", Web.getParams(), new Routes() );
		}
	}


	public static function main() 
	{  
		var main = new Main();
	}
}

