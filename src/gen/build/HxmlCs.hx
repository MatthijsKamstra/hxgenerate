package gen.build;

using StringTools;

class HxmlCs extends HxmlBase implements IHxmlBase {

	public function new(?isDebug = true) {
		super(isDebug);
		init();
	}

	function init ()
	{
		_name = "Cs / C#";
		_libs      = '#-lib format\n#-lib markdown\n-lib haxelow';
		_target    = '-cs bin/cs'; // str += '-${target} bin/${sanitize(projectName)}.exe';
		_run       = '-cmd cd bin/cs/bin\n-cmd mono Main.exe';
	}


}