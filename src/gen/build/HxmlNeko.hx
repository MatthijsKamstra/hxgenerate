package gen.build;

using StringTools;

class HxmlNeko extends HxmlBase implements IHxmlBase {

	public function new(?isDebug = true) {
		super(isDebug);
		init();
	}

	function init ()
	{
		_name = "Neko";
		_libs      = '#-lib format\n#-lib markdown\n';
		_target    = '-::projectTarget:: bin/::sprojectName::.n'; // 	str += '-${target} bin/${sanitize(projectName)}.n';
		_run       =
'# Run ::projectTarget:: application
# -cmd nekotools boot bin/::sprojectName::.n
# -cmd ::projectTarget:: bin/::sprojectName::.n
';
	}


}