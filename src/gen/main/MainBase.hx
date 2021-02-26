package gen.main;

using StringTools;

class MainBase implements IMainBase {
	public var FUNC = '::func::';
	public var IMPORT = '::import::';
	public var VARS = '::vars::';

	public var _import = '';
	public var _vars = '';
	public var _func = '';

	public var baseTemplate = 'package;
::import::
/**
 * @author ::projectAuthor::
 * ::projectLicense::
 * ::projectWebsite::
 */
class ::classname:: {
	::vars::
	public function new () {
		trace( "Hello \'::projectName::\'" );
	}
	::func::
	static public function main () {
		var app = new ::classname:: ();
	}
}
';

	public function new() {}

	public function template():String {
		return baseTemplate.replace(IMPORT, _import).replace(VARS, _vars).replace(FUNC, _func);
	}
}
