package gen.build;

using StringTools;

class HxmlCpp extends HxmlBase implements IHxmlBase {
	public function new(?isDebug = true) {
		super(isDebug);
		init();
	}

	function init() {
		_name = "C++";
		_libs = '#-lib format\n#-lib markdown\n';
		_target = '-::projectTarget:: bin'; // '-${target} bin';
		_run = '
# Run ::projectTarget:: application
# -cmd bin/Main-debug
';
	}
}
