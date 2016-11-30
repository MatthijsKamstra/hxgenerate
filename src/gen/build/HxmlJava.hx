package gen.build;

using StringTools;

class HxmlJava extends HxmlBase implements IHxmlBase {

	public function new(?isDebug = true) {
		super(isDebug);
		init();
	}

	function init ()
	{
		_name = "Java";
		_libs      = '#-lib format\n#-lib markdown\n';
		_target    = '-::projectTarget:: bin/java'; // str += '-${target} bin/java';// ${sanitize(projectName)}.jar';
		_run       =
'
# Run ::projectTarget:: application
# -cmd cd bin/java
# -cmd java -jar Main-Debug.jar
';




	}


}