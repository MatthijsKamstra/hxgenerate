package gen.build;

using StringTools;

class HxmlPhp extends HxmlBase implements IHxmlBase {
	public function new(?isDebug = true) {
		super(isDebug);
		init();
	}

	function init() {
		_name = "PHP";
		_libs = '#-lib format\n#-lib markdown';
		_target = '-::projectTarget:: bin/www';

		_run = '# Run ::projectTarget:: application
# -cmd open -a Google\\ Chrome http://localhost:2000/
# Copy folder with images
# -cmd cp -R src/assets/img bin/www
# Copy .htaccess file
# -cmd cp -R src/assets/.htaccess bin/www
';
	}
}
