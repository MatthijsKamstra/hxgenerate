package gen.build;

using StringTools;

class HxmlNode extends HxmlBase implements IHxmlBase {
	public function new(?isDebug = true) {
		super(isDebug);
		init();
	}

	function init() {
		_name = "Node.js";
		_libs = '-lib js-kit\n-lib hxnodejs';
		_target = '-js bin/::sprojectName::.js

# You can use -D source-map-content (requires Haxe 3.1+) to have the .hx
# files directly embedded into the map file, this way you only have to
# upload it, and it will be always in sync with the compiled .js even if
# you modify your .hx files.
-D source-map-content

# Don\'t generate node.js version warning when -D hxnodejs-no-version-warning
# -D hxnodejs_no_version_warning

# For cleaner JavaScript output, since node.js is ES5-compilant
#-D js-es5
';

		_run = '# Run ::projectTarget:: application as node.js
# -cmd cd bin
# -cmd node ::sprojectName::.js
';
	}
}
