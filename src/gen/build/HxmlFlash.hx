package gen.build;

using StringTools;

class HxmlFlash extends HxmlBase implements IHxmlBase {
	public function new(?isDebug = true) {
		super(isDebug);
		init();
	}

	function init() {
		_name = "Flash";
		_libs = '# -lib js-kit\n# -lib hxnodejs\n';
		_target = ''; // str += '-swf bin/${sanitize(projectName)}.swf';
		_run = '';
	}
}
