package gen.build;

using StringTools;

class HxmlJS extends HxmlBase implements IHxmlBase {
	public function new(?isDebug = true) {
		super(isDebug);
		init();
	}

	function init() {
		targetName = "Lua";
		_libs = '#-lib format\n#-lib markdown\n';
		_target = ''; // ?
		_run = '';
	}
}
