package ;


import sys.io.File;
import sys.io.FileOutput;
import sys.FileSystem;

import gen.main.*;
import gen.build.*;

using StringTools;

/**
 * @author Matthijs Kamstra  aka [mck]
 * MIT
 * http://www.matthijskamstra.nl
 */
class Main
{
	/**
	* 0.3.1 added tasks.json in vscode folder
	* 0.3.0 added hxformat, vscode folder returns, small update on C# target
	* 0.2.2 bootstrap version
	* 0.2.1 bootstrap version, added project name to app constants
	* 0.2.0 electron
	* 0.1.8 cleaning up some file, add real data for Heroku: Procfile, .env, package.json
	* 0.1.7 remove jQueryExtern, update bootstrap 4
	* 0.1.6 remove VSCode folder
	* 0.1.5 haxelib.json added, removed folder ref.
	* 0.1.4 haxelib run added
	* 0.1.3 initial files for meteor added
	* 0.1.2 docker file added, in combination with gitlab, -x working for docker/gitlab
	* 0.1.1 yml file for node.js projects (gitlab) / add .version file
	* 0.1.0 bin favicon / hxml generation with debug / update haxe info and build_all / gitignore node_modules
	* 0.0.9 build_debug build_release
	* 0.0.8 removed _build_vscode again (hxml our now without -cmd etc stuff), Main-Node/PHP added
	* 0.0.7 create custom Main.hx files based upon target
	* 0.0.6 added openfl
	* 0.0.5 Virtual studio code stuff added
	* 0.0.4 neko target
	* 0.0.3 -x added, using haxe.template
	* 0.0.2 update all target, add more output nicities
	* 0.0.1 initial
	*/
	private var VERSION : String = '0.3.1';

	private var projectFolder 	: String = '';
	private var projectTarget 	: String = 'js';
	private var projectName 	: String = 'Foobar';
	private var projectAuthor 	: String = 'Matthijs Kamstra aka [mck]';
	private var projectLicense 	: String = 'MIT';
	private var projectWebsite 	: String = '';
	private var projectXType 	: Array<String> = [];

	// private var targetArr : Array<String> = ["cpp", "js", "javascript", "flash", "neko", "php", "cs", "java", "python", 'lua', 'node', 'nodejs', 'node.js', 'openfl'];
	private var targetArr : Array<String> = ["cpp", "js", "flash", "neko", "php", "cs", "java", "python", 'lua', 'node', 'openfl'];
	private var xtargetArr : Array<String> = ['test','flux','openfl','heroku','gitlab','docker', 'meteor', 'electron'];

	var isXperimental: Bool = false;

	public function new(?args : Array<String>) : Void
	{
		readConfig();

		var args : Array<String> = args;

		var isFolderSet : Bool = false;

		for ( i in 0 ... args.length ) {
			var temp = args[i];
			switch (temp) {
				case '-cd','-folder': 		projectFolder = validateFolder(args[i+1]); isFolderSet = true;
				case '-name', '-n': 		projectName = args[i+1];
				case '-license', '-l': 		projectLicense = args[i+1];
				case '-author','-a': 		projectAuthor = args[i+1];
				case '-target','-t': 		projectTarget = validateTarget(args[i+1]);
				case '-website','-w': 		projectWebsite = args[i+1];
				case '-help','-h': 			showHelp();
				case '-x': 					projectXType.push(validateXType(args[i+1])); isXperimental = true;

				// default : trace ("case '"+temp+"': trace ('"+temp+"');");
			}
		}

		if (!isFolderSet){
			Sys.println('ERROR :: Sorry I need a folder to export to');
			showHelp();
			return;
		}

		Sys.println('HxGenerate :: start');

		showSettings();

		createFolder(sanitize(projectName));
		createFolder(sanitize(projectName)+'/bin');
		createFolder(sanitize(projectName)+'/src');
		createFolder(sanitize(projectName)+'/docs');
		createFolder(sanitize(projectName)+'/_build');
		createFolder(sanitize(projectName)+'/.vscode');

		createHx(sanitize(projectName)+'/src','Main.hx');
		createTargetSpecific(projectTarget);
		createBuildTargets(sanitize(projectName)+'/_build');
		createHxmlAll(sanitize(projectName),'build_all.hxml');
		createHxml(sanitize(projectName),'build.hxml', projectTarget);
		createHxml(sanitize(projectName),'build_release.hxml', projectTarget, false);
		createHxml(sanitize(projectName),'build_debug.hxml', projectTarget, true);
		createHaxelib(sanitize(projectName),'haxelib.json');
		createPackage(sanitize(projectName),'package.json', projectTarget);
		createReadme(sanitize(projectName),'README.MD');
		createReadme(sanitize(projectName),'README_HAXE.MD', true);
		createBuild(sanitize(projectName),'BUILD.MD');
		createTodo(sanitize(projectName),'TODO.MD');
		createGitignore(sanitize(projectName),'.gitignore');
		createIcon(sanitize(projectName),'icon.png');
		createHxformat(sanitize(projectName),'hxformat.json');
		createFavicon(sanitize(projectName)+'/bin');
		createVSCode(sanitize(projectName)+'/.vscode');
		createVersion(sanitize(projectName));

		writeConfig();

		// createZip();
		// createImage();

		if(isXperimental) createXperimental(projectXType);

		Sys.println('HxGenerate :: done');
	}

	// ____________________________________ validate ____________________________________

	public function validateTarget (target:String) : String
	{
		var isValidTarget = false;
		// [mck] maybe some extra checks for 'node, nodejs, node.js', 'js, javascript, JavaScript'
		for ( i in 0 ... targetArr.length ) {
			if(target.toLowerCase() == targetArr[i]) isValidTarget = true;
		}
		if(!isValidTarget) Sys.println('ERROR :: I don\'t know this target (${target}), must be an experimental');
		return target.toLowerCase();
	}

	function validateXType (type:String) : String
	{
		var str = '';
		if(type != null && !type.startsWith('-')){
			str = type;
		}
		return str;
	}

	/*
	*  clean up folder structure
	* 	 - no spaces at the start and end of the path
	* 	 - has to end with a backslash ("/")
	* 	 - remove \ to escape folder structures with spaces in it `Volume/foobar/this\ is\ bad/`
	*/
	function validateFolder (folder:String) : String
	{
		folder = folder.ltrim().rtrim();
		folder = folder.replace("\\ "," ");
		if (folder.charAt(folder.length-1) != "/"){
			folder += "/";
		}
		return folder;
	}

	/**
	 * NPM project.json / folder-names
	 *		- name must be lower-case
	 * 		- no spaces in the name
	 */
	private function sanitize(str:String) : String
	{
		return str.replace('.', '_').replace(' ', '_').replace(':', '').replace('/','').replace('+','p').toLowerCase();
	}

	// ____________________________________ config ____________________________________

	function readConfig() : Void
	{
		var folder = Sys.getCwd();
		var json : HxGenConfig;
		if (sys.FileSystem.exists(folder + 'hxgenerate.json')) {
			var str = (sys.io.File.getContent(folder +  'hxgenerate.json'));
			json = haxe.Json.parse(str);
			projectFolder 	= json.folder;
			projectTarget 	= json.target;
			projectName 	= json.name;
			projectAuthor  	= json.author;
			projectLicense 	= json.license;
		} else {
			Sys.println('ERROR: can\'t find the config (${folder}hxgenerate.json)');
		}
	}

	function writeConfig() : Void
	{
		var temp : HxGenConfig =
		{
			folder : projectFolder,
			target : projectTarget,
			name : projectName,
			author : projectAuthor,
			license : projectLicense,
			website : projectWebsite
		}

		writeFile('../','hxgenerate.json',haxe.Json.stringify(temp));
		Sys.println('\tcreate config');
	}

	// ____________________________________ create files/folders ____________________________________

	private function writeFile (path:String, name:String, content:String) : Void
	{
		sys.io.File.saveContent(projectFolder + path + '/' + name, content);
	}

	private function createFolder(name:String) : Void
	{
		if (!sys.FileSystem.exists(projectFolder + name)) {
			try {
				sys.FileSystem.createDirectory(projectFolder + name);
			} catch(e:Dynamic){
				trace(e);
			}
		}
		Sys.println('\tcreate folder - $name');
	}

	// function copyFolder (){
	// 	if (!sys.FileSystem.exists(projectFolder + name)) {
	// 		try {
	// 			sys.FileSystem.createDirectory(projectFolder + name);
	// 		} catch(e:Dynamic){
	// 			trace(e);
	// 		}
	// 	}
	// 	// Sys.println('\tcreate folder - $name');
	// }

	// ____________________________________ create files ____________________________________

	function createTargetSpecific (target:String){
		switch (target) {
		  	case 'neko' :
			  	createWithTemplate(sanitize(projectName),'test.hxml', 'buildNeko');
			case 'python':
				// do something clever for python
			case 'js', 'node', 'nodejs', 'node.js':
				// do something clever for nodejs AND Js
				createFolder(sanitize(projectName)+'/bin/public');
				createFolder(sanitize(projectName)+'/bin/public/css');
				createFolder(sanitize(projectName)+'/bin/public/js');
				createFolder(sanitize(projectName)+'/bin/public/img');
				createFolder(sanitize(projectName)+'/bin/_data');
				createFolder(sanitize(projectName)+'/src/api');
				createFolder(sanitize(projectName)+'/src/model');
				createFolder(sanitize(projectName)+'/src/model/vo');
				createFolder(sanitize(projectName)+'/src/model/constants');
				createWithTemplate(sanitize(projectName)+'/src/model/constants','App.hx', 'App');
				createIndex(sanitize(projectName)+'/bin','index.html');
			case 'php':
				createFolder(sanitize(projectName)+'/bin/www');
				createFolder(sanitize(projectName)+'/src/assets');
				createFolder(sanitize(projectName)+'/src/assets/font');
				createFolder(sanitize(projectName)+'/src/assets/img');
				createFolder(sanitize(projectName)+'/src/assets/css');
				createFolder(sanitize(projectName)+'/src/assets/mtt');
				createFolder(sanitize(projectName)+'/src/model');
				createFolder(sanitize(projectName)+'/src/model/constants');
				createFolder(sanitize(projectName)+'/src/model/vo');
				createFolder(sanitize(projectName)+'/src/view');
				createFolder(sanitize(projectName)+'/src/controller');
				// createWithTemplate(sanitize(projectName)+'/src','Main.hx', 'MainPHP');
				writeFile(sanitize(projectName)+'/src/assets','.htaccess', 'RewriteEngine On\n# RewriteBase /xbeacon/\n\n# Checks to see if the user is attempting to access a valid file,\n# such as an image or css document, if this isn\'t true it sends the\n# request to index.php\n#\nRewriteCond %{REQUEST_FILENAME} !-f\nRewriteCond %{REQUEST_FILENAME} !-d\n\n# Default is redirecting to index.php.\n# If you\'re using Neko, you must change this to index.n.\n#\nRewriteRule ^(.*)$ index.php/$1 [L]');
				writeFile(sanitize(projectName)+'/src','Route.hx', '// clever stuff');
			case 'openfl':
				createFolder(sanitize(projectName)+'/Assets');
				createWithTemplate(sanitize(projectName),'project.xml', 'buildOpenfl');
				createWithTemplate(sanitize(projectName)+'/src','Main.hx', 'MainOpenfl');

			// default : trace ("case '"+target+"': trace ('"+target+"');");
		}
	}

	/**
	 * create a Main.hx file specific for projectTarget
	 *
	 * @param		path  			where Should the file be saved (example : sanitize(projectName)+'/src')
	 * @param		name    		name of the file (example: 'Main.hx')
	 */
	private function createHx(path:String, name:String) : Void
	{
		switch (projectTarget) {
			case 'js':
				var template = new MainJS().template();
				createWithGenTemplate(path, name, template);
			case 'node', 'node.js', 'nodejs':
				var template = new MainNode().template();
				createWithGenTemplate(path, name, template);
			case 'php':
				var template = new MainPHP().template();
				createWithGenTemplate(path, name, template);
			case 'cs':
				var template = new MainCS().template();
				createWithGenTemplate(path, name, template);
			default:
				var template = new MainBase().template();
				createWithGenTemplate(path, name, template);
		}
		Sys.println('\tcreate ${name}');
	}


	/**
	 * createWithTemplate
	 *
	 * @param		path  			where Should the file be saved (example : sanitize(projectName)+'/src')
	 * @param		name    		name of the file (example: 'Main.hx')
	 * @param		templateName	name of the template (default 'Main')
	 */
	function createWithTemplate(path:String, name:String, templateName:String) : Void
	{
		var str = haxe.Resource.getString('$templateName');
        createWithGenTemplate(path, name, str);
		// Sys.println('\tcreate template ${name}');
	}

	/**
	 * createWithGenTemplate
	 *
	 * @param		path  			where Should the file be saved (example : sanitize(projectName)+'/src')
	 * @param		name    		name of the file (example: 'Main.hx')
	 * @param		template		template string
	 */
	function createWithGenTemplate(path:String, name:String, template:String) : Void
	{
        var t = new haxe.Template(template);
        var output = t.execute({
			projectAuthor : projectAuthor,
			projectFolder : projectFolder,
			projectLicense: projectLicense,
			projectWebsite : projectWebsite,
			projectName : projectName,
			projectTarget : projectTarget,
			sprojectName : sanitize(projectName),
			classname : name.split('.')[0]
		});

		writeFile(path, name, output);
		Sys.println('\tcreate template "${name}"');
	}

	private function createIndex(path:String, name:String) : Void
	{
		createWithTemplate(path, name, "index");
		Sys.println('\tcreate $name');
	}

	function createHxmlAll(path:String, name:String){
		createWithTemplate(path, name, "buildAll");
		Sys.println('\tcreate $name');
	}

	private function createHxml(path:String, name:String, target:String, ?isDebug = true, ?content:String ) : Void
	{
		var template = '';

		// [mck] every target should have it's own export setting
		switch (target) {
			// case 'cpp': template = '-${target} bin';
			// case 'cs': 							str += '-${target} bin/${sanitize(projectName)}.exe';
			// case 'java': 						str += '-${target} bin/java';// ${sanitize(projectName)}.jar';
			// case 'flash': 						str += '-swf bin/${sanitize(projectName)}.swf';
			// case 'neko': 						str += '-${target} bin/${sanitize(projectName)}.n';
			// case 'python': 						str += '-${target} bin/${sanitize(projectName)}.py';
			case 'cpp': template  = new HxmlCpp(isDebug).template();
			case 'cs': template  = new HxmlCs(isDebug).template();
			case 'java': template  = new HxmlJava(isDebug).template();
			case 'flash': template  = new HxmlFlash(isDebug).template();
			case 'neko': template  = new HxmlNeko(isDebug).template();
			case 'python': template  = new HxmlPython(isDebug).template();
			case 'js' :	 template = new HxmlJs(isDebug).template();
			case 'node': template = new HxmlNode(isDebug).template();
			default :  template = new HxmlBase(isDebug).template();
		}

		var t = new haxe.Template(template);
    	var output = t.execute({
			projectAuthor : projectAuthor,
			projectFolder : projectFolder,
			projectLicense: projectLicense,
			projectWebsite : projectWebsite,
			projectName : projectName,
			projectTarget : projectTarget,
			sprojectName : sanitize(projectName),
			classname : name.split('.')[0]
		});

 		if(content != null) output = content;

		writeFile(path, name, output);
		Sys.println('\t\tcreate ${target}.hxml');
	}

	function createBuildTargets (path:String)
	{
		Sys.println('\tcreate all buildtarget');
		for ( i in 0 ... targetArr.length ) {
			createHxml(path, '${targetArr[i]}.hxml', targetArr[i]);
		}
	}

	function createPackage(path:String, name:String, target:String) : Void
	{
		switch (target) {
			case 'node':
				createWithTemplate(path, name, "packageNode");
			case 'heroku':
				createWithTemplate(path, name, "packageHeroku");
			case 'js':
				createWithTemplate(path, name, "packageJs");
			default:
				createWithTemplate(path, name, "package");
		}

		Sys.println('\tcreate createPackage');
	}

	function createHaxelib(path:String, name:String) : Void
	{
		createWithTemplate(path, name, "haxelib");

		Sys.println('\tcreate createHaxelib');
	}

	function createVSCode (path:String)
	{
		createWithTemplate(path, 'settings.json', "vscodeSettings");
		createWithTemplate(path, 'launch.json', "vscodeLaunch");
		createWithTemplate(path, 'tasks.json', "vscodeTasks");
		// if(projectTarget == 'node'){
		// 	createWithTemplate(path, 'launch.json', "vscodeLaunch");
		// }
		Sys.println('\tcreate createVSCode');
	}

	function createVersion (path:String)
	{
		var str = '$VERSION';
		writeFile(path, '.version', str);
		Sys.println('\tcreate .version');
	}

	function createReadme(path:String, name:String, ?isHaxe:Bool = false) : Void
	{
		if(isHaxe){
			createWithTemplate(path, name, "readmeHaxe");
		} else {
			createWithTemplate(path, name, "readme");
		}
		// Sys.println('\tcreate createReadme');
	}

	function createTodo(path:String, name:String) : Void
	{
		var str = '# TODO\n\n> a journey of a thousand miles begins with a single step\n\n';
		writeFile(path, name, str);
		Sys.println('\tcreate TODO');
	}

	function createIcon(path:String, name:String) : Void
	{
		var bytes = haxe.Resource.getBytes('icon');
		var fo:FileOutput = sys.io.File.write(projectFolder + path + '/' + name, true);
		fo.write(bytes);
		fo.close();
		Sys.println('\tcreate icon');
	}

	function createHxformat(path:String, name:String) : Void
	{
		var str = '{"wrapping": {"methodChain": {"defaultWrap": "keep","rules": []}}}';
		writeFile(path, name, str);
		Sys.println('\tcreate hxformat.json');
	}

	function createFavicon(path:String) : Void
	{
		var bytes = haxe.Resource.getBytes('favicon');
		var fo:FileOutput = sys.io.File.write(projectFolder + path + '/favicon.ico', true);
		fo.write(bytes);
		fo.close();
		Sys.println('\tcreate favicon');
	}

	function createZip()
	{
		var bytes = haxe.Resource.getBytes('fluxzip');
		var bytesInput = new haxe.io.BytesInput(bytes);
		var entries = haxe.zip.Reader.readZip( bytesInput );

		// [mck] flux specific

		for (entry in entries){
			if(entry.fileName.indexOf('__MACOSX') != -1) continue;
			trace ("read entry " + entry.fileName + " : " + entry.fileSize);
		}

	}

	function createImage()
	{
		var bytes = haxe.Resource.getBytes('eboy');
		var pngInput = new haxe.io.BytesInput(bytes);
		var pngReader = new format.png.Reader(pngInput);
		var pngData:format.png.Data = pngReader.read();


		var data = format.png.Tools.buildRGB (400,400,bytes);
        var out = sys.io.File.write(projectFolder + sanitize(projectName) + '/' + '_foobar.png',true);
        new format.png.Writer(out).write(data);

		// pngByt = Tools.extract32(pngData);
		// var bmp:BitmapData = new BitmapData(33, 40);
		// var byteArray:flash.utils.ByteArray = pngByt.getData();
		// byteArray.position = 0;
		// bmp.setPixels(new Rectangle(0, 0, 33, 40), byteArray);
		// add(new FlxSprite(0, 0, bmp));
	}


	function createBuild(path:String, name:String) : Void
	{
		var str = '# Build ${projectName}

Default methode to build this project

```
cd \'${projectFolder}${sanitize(projectName)}\'
haxe build.hxml
echo done
```

# Type of build

- `build.hxml` 			: default start for (debug) build
- `build_all.hxml` 		: start release and debug build
- `build_debug.hxml` 	: start for (debug) build
- `build_release.hxml` 	: start for (release) build

';

	switch (projectTarget) {
		case 'java': str += 'cd \'${projectFolder}${sanitize(projectName)}/bin/java\'';
		case 'php': str += 'cd \'${projectFolder}${sanitize(projectName)}/bin/www\'';
		case 'node', 'nodejs', 'node.js': str += '
# Build ${projectName} and start node.js

```
cd \'${projectFolder}${sanitize(projectName)}/bin/www\'';
		case 'js': str += '
# Build ${projectName} and start nekoserver and browser

Same as previous, but also start nekoserver and open Google Chrome browser.

Great for testing js
> Cross origin requests are only supported for protocol schemes: http, data, chrome, chrome-extension, https, chrome-extension-resource.

```
cd \'${projectFolder}${sanitize(projectName)}\'
haxe build.hxml
';
		default : str += 'cd \'${projectFolder}${sanitize(projectName)}\'';
	}

	str += '
open -a Google\\ Chrome http://localhost:2000/
nekotools server

```
';
	str += '
# Build ${projectName} using NPM watch

```
cd \'${projectFolder}${sanitize(projectName)}\'
npm run watch

```

# Install all (haxe)dependencies with haxelib
```
haxelib install build.hxml
```

# Install all (node)dependencies with NPM (node.js)
```
npm install
```

';

		writeFile(path, name, str);
		Sys.println('\tcreate createBuild');
	}


	// TODO create custom gitignores
	// ignore some files I generate
	function createGitignore (path:String, name:String) : Void
	{
		// var str = 'BUILD.MD\n.DS_Store\ntest.hxml\n';
		// var str = '#https://github.com/github/gitignore\n\nBUILD.MD\n.DS_Store\ntest.hxml\n\nnode_modules\n\n_build\nbin\nbin_test\nbin_release';
		var str = haxe.Resource.getString('GitIgnore');
		writeFile(path, name, str);
		Sys.println('\tcreate createGitignore');
	}

	function createXperimental(arr: Array<String>)
	{

		for (i in 0 ... arr.length) {
			var type = arr[i].toLowerCase();
			// [mck] should be a combination of project vs -x name
			Sys.println('\tcreate "$type" specific files');
			switch (type)
			{
				case 'test' :
					createWithTemplate(sanitize(projectName)+'/src','Test.hx', 'Class');
				case 'flux' :
					createFolder(sanitize(projectName)+'/src/store');
					createZip();
					// createImage(); // [mck] needs more love
					createWithTemplate(sanitize(projectName)+'/src/store','Store.hx', 'Singleton');
				case 'openfl':
					trace('fix this');
				case 'heroku':
					// trace(':: heroku stuff ::');
					writeFile(sanitize(projectName) + "/bin", "Procfile", "web: node index.js");
					writeFile(sanitize(projectName) + "/bin", ".env", "TIMES=2");
					createPackage(sanitize(projectName) + "/bin", "package.json", "heroku");
var buildheroku =
'# BUILD heroku

<https://devcenter.heroku.com/articles/getting-started-with-nodejs#introduction>

## Login on Heroku and check versions

```
heroku login
# get version of node, npm and git
node -v
npm -v
git --version
```


## make sure all files are installed

globally

```
cd bin/heroku
npm install -g
```

## Update Heroku

```
cd bin/heroku
git push heroku master
heroku ps:scale web=1
heroku open
```

## Run locally

```
cd bin/heroku
echo `Open http://localhost:5000 with your web browser!`
echo `Ctrl+C to exit`
heroku local web

```

';

var build = '
-lib js-kit
-lib hxnodejs
-cp src
-main Main
-js bin/heroku/index.js
-D source-map-content
# -D hxnodejs_no_version_warning
-D state=debug
-debug
-dce full
';

					writeFile(sanitize(projectName), "BUILD_HEROKU.MD", buildheroku);
					writeFile(sanitize(projectName), "build_heroku.hxml", build);
				case 'gitlab':
					// trace(':: gitlab stuff ::');
					// createGitLab(sanitize(projectName),'.gitlab-ci.yml', projectTarget);
					createWithTemplate(sanitize(projectName),'.gitlab-ci.yml','Gitlab');
					// createFolder(sanitize(projectName)+'/docs');
				case 'docker':
					// trace(':: docker stuff ::');
					createWithTemplate(sanitize(projectName),'Dockerfile','DockerFile');
					createWithTemplate(sanitize(projectName),'.dockerignore','DockerIgnore');
				case 'electron':
					trace(':: electron stuff ::');
					// createWithTemplate(sanitize(projectName),'Dockerfile','DockerFile');
					// createWithTemplate(sanitize(projectName),'.dockerignore','DockerIgnore');
					createFolder(sanitize(projectName)+'/download');

					createWithTemplate(sanitize(projectName)+'/bin', "package.json", 'packageElectron');
					createWithTemplate(sanitize(projectName)+'/src', "Main.hx", 'MainElectron');
					createWithTemplate(sanitize(projectName)+'/src', "MainMenu.hx", 'MainMenuElectron');
					createWithTemplate(sanitize(projectName)+'/src', "MainServer.hx", 'MainServerElectron');



				case 'meteor':
					trace(':: meteor stuff ::');
					createFolder(sanitize(projectName)+'/www');
					createFolder(sanitize(projectName)+'/src/client');
					createFolder(sanitize(projectName)+'/src/client/templates');
					createFolder(sanitize(projectName)+'/src/server');
					createFolder(sanitize(projectName)+'/src/shared');
					createFolder(sanitize(projectName)+'/src/shared/model');
					createFolder(sanitize(projectName)+'/bin/server');
					createFolder(sanitize(projectName)+'/bin/client');
					createFolder(sanitize(projectName)+'/bin/client/lib');
					createFolder(sanitize(projectName)+'/bin/client/lib/css');
					createFolder(sanitize(projectName)+'/bin/client/lib/js');
					createFolder(sanitize(projectName)+'/bin/client/style');
					createFolder(sanitize(projectName)+'/bin/client/templates');
					createFolder(sanitize(projectName)+'/bin/public');
					createFolder(sanitize(projectName)+'/bin/public/img');
					createFolder(sanitize(projectName)+'/bin/public/fonts');

					createWithTemplate(sanitize(projectName)+'/src/client/templates/','Home.hx','Class');
					createWithTemplate(sanitize(projectName)+'/src/client/','Client.hx','Class');
					createWithTemplate(sanitize(projectName)+'/src/server/','Server.hx','Class');
					createWithTemplate(sanitize(projectName)+'/src/shared/','Shared.hx','Class');
					createWithTemplate(sanitize(projectName)+'/src/shared/','AppRouter.hx','Class');
					createWithTemplate(sanitize(projectName)+'/src/shared/model/','Model.hx','Class');
					// writeFile(sanitize(projectName)+'/src/client/templates/', 'Home.hx', 'package template;\n\nclass Home {\n\tstatic public function init(){\n\n\t}\n}');

				default:
					trace('unknown x target: $type');
			}
		}

		// switch (projectTarget.toLowerCase())
		// {
		// 	case 'neko':
		// 		createWithTemplate(sanitize(projectName)+'/src','Main.hx', 'MainNeko');
		// 		createFolder(sanitize(projectName)+'/src/assets');
		// 		// TODO [mck] create .mtt file

		// 	default : Sys.println('\tthere is no -x for ${projectTarget} yet!');
		// }
	}

	// ____________________________________ show app stuff ____________________________________

	function showSettings() : Void
	{
		Sys.println('------------------

projectFolder : ${projectFolder}${sanitize(projectName)}
projectTarget : ${projectTarget}
projectName : ${projectName}
projectAuthor : ${projectAuthor}
projectLicense : ${projectLicense}

------------------');
	}


	function showHelp () : Void {
		Sys.println('
HX-GENERATE :: version $VERSION

how to use:
neko hxgenerate -cd \'path/to/folder\' -name \'${projectName}\' -license \'${projectLicense}\' -author \'${projectAuthor}\' -target \'${projectTarget}\'

	-help : show this help
	-cd or -folder : path to project folder
	-name : project Name (name also used for the name of the generate folder)
	-license : project license (MIT, etc)
	-author : project author (you?)
	-website : project website (from you?)
	-target : project target : ${targetArr}

	-x : experimental project generation : ${xtargetArr}

');
	}


	// ____________________________________ jump start everything ____________________________________

    static public function main()
    {
		// [mck] this doesn't work in neko...?

		//  // print a message on the screen
        // Sys.println("What's your name?");
        // // read user input
        // var input = Sys.stdin().readAll();
        // // print the result
        // Sys.println("Hello " + input);

		// trace('environment: ' +  Sys.environment());
		// trace('executablePath: ' + Sys.executablePath());
		// trace('cwd: ' + Sys.getCwd());

		var app = new Main(Sys.args());
	}
}

typedef HxGenConfig =
{
	var folder : String;// = 'path/to/folder';
	var target : String;// = 'js';
	var name : String;// = 'Foobar';
	var author : String;// = 'Matthijs Kamstra aka [mck]';
	var license : String;// = 'MIT';
	var website : String;
}

enum HaxeTarget {
	Php;
	Neko;
	Flash;
	Js;
	Cpp;
	Cs;
	Python;
	Lua;
}