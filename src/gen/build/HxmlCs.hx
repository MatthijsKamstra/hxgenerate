package gen.build;

using StringTools;

class HxmlCs extends HxmlBase implements IHxmlBase {

	public function new(?isDebug = true) {
		super(isDebug);
		init();
	}

	function init ()
	{
		_name = "Cs";
		_libs      = '#-lib format\n#-lib markdown\n';
		_target    = ''; // str += '-${target} bin/${sanitize(projectName)}.exe';
		_run       = '';
	}


}