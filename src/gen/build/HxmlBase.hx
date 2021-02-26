package gen.build;

using StringTools;

class HxmlBase implements IHxmlBase {
	public var isDebug:Bool;

	public var NAME = '::targetname::';
	public var LIBS = '::libs::';
	public var TARGET = '::target::';
	public var RUN = '::run::';
	public var DEBUG = '::debug::';
	public var STATE = '::STATE::';

	public var _name = 'Haxe';
	public var _libs = '#-lib foobar';
	public var _target = '-::projectTarget:: bin/::sprojectName::.::projectTarget::'; // value for specific target
	public var _run = ''; // value for specific target

	private var _debug = '-debug';
	private var _state = '-D state=debug';

	public var baseTemplate = '# Libraries you like to use (http://lib.haxe.org/)
::libs::

# Integrate files to classpath
-cp src

# This class wil be used as entry point for your app.
-main Main

# ::targetname:: target
::target::

# Compiler flag is a configurable value which may influence the compilation process.
::STATE::

# Add debug information
::debug::

# Dead code elimination : remove unused code
# "-dce no" : do not remove unused code
# "-dce std" : remove unused code in the std lib (default)
# "-dce full" : remove all unused code
-dce full

# Resources like templates
# -resource src/assets/LICENSE@licence

# Additional commandline actions can be done here
# -cmd cp -R src/assets/img bin/www

--next

# run application
::run::

# Add extra targets
# --next
';

	public function new(isDebug) {
		this.isDebug = isDebug;
		if (!this.isDebug) {
			_debug = '#-debug\n\n--no-traces';
			_state = '-D state=release';
		}
	}

	public function template():String {
		return baseTemplate.replace(NAME, _name)
			.replace(LIBS, _libs)
			.replace(TARGET, _target)
			.replace(RUN, _run)
			.replace(DEBUG, _debug)
			.replace(STATE, _state);
	}
}
