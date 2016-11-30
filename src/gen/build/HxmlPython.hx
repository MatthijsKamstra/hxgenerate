package gen.build;

using StringTools;

class HxmlPython extends HxmlBase implements IHxmlBase {

	public function new(?isDebug = true) {
		super(isDebug);
		init();
	}

	function init ()
	{
		_name = "Python";
		_libs      = '#-lib format\n#-lib markdown\n';
		_target    = '-::projectTarget:: bin/::sprojectName::.py'; // str += '-${target} bin/${sanitize(projectName)}.py';
		_run       =
'# Run ::projectTarget:: application
# -cmd bin
# -cmd python3 ::sprojectName::.py
';


	}


}