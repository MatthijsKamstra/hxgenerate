package gen.main;

using StringTools;

class MainPHP extends MainBase implements IMainBase {



	public function new() {
		super();
		init();
	}

	function init ()
	{
		_import =
'
import haxe.web.Dispatch;
import haxe.web.Dispatch.DispatchError;

#if neko
	import neko.Web;
#elseif php
	import php.Web;
#end
';

		_vars =
'';

		_func =
'
	function init(){
		// trace("::projectName::");
		try {
			var _webURI = Web.getURI();
			Dispatch.run(_webURI, Web.getParams(), new Routes() );
		} catch (e:DispatchError) {
			Dispatch.run("/", Web.getParams(), new Routes() );
		}
	}
';
	}

	// override public function template() : String
	// {
	// 	return baseTemplate.replace(IMPORT,import).replace(VARS, vars).replace(FUNC, func);
	// }

}