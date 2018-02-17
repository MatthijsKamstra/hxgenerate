package gen.build;

using StringTools;

class HxmlJs extends HxmlBase implements IHxmlBase {

	public function new(?isDebug = true) {
		super(isDebug);
		init();
	}

	function init ()
	{
		_name   = "JavaScript";
		_libs   = '#-lib js-kit\n#-lib hxnodejs#\n# -lib vue\n# -lib hxexterns\n# -lib haxelow';
		_target =
'-::projectTarget:: bin/::sprojectName::.js

# You can use -D source-map-content (requires Haxe 3.1+) to have the .hx
# files directly embedded into the map file, this way you only have to
# upload it, and it will be always in sync with the compiled .js even if
# you modify your .hx files.
-D source-map-content
';

		_run    =
'# Run ::projectTarget:: application
# -cmd cd bin
# -cmd open -a Google\\ Chrome http://localhost:2000/
# -cmd nekotools server
';
	}


}