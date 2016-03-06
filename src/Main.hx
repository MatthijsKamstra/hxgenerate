package ;


import sys.io.File;
import sys.io.FileOutput;
import sys.FileSystem; 

using StringTools;

/**
 * @author Matthijs Kamstra  aka [mck]
 * MIT
 * http://www.matthijskamstra.nl
 */
class Main
{
	
	private var projectFolder 	: String = "";
	private var projectTarget 	: String = 'js';
	private var projectName 	: String = 'Foobar';
	private var projectAuthor 	: String = 'Matthijs Kamstra aka [mck]';
	private var projectLicense 	: String = 'MIT';
	
	
	public function new(?args : Array<String>) : Void
	{
		readConfig();
		
		var args : Array<String> = args;
		
		var isFolderSet : Bool = false;

		for ( i in 0 ... args.length ) {
			var temp = args[i];
			switch (temp) {
				case '-cd','-folder': projectFolder = args[i+1]; isFolderSet = true;
				case '-name': projectName = args[i+1];
				case '-license': projectLicense = args[i+1];
				case '-author': projectAuthor = args[i+1];
				case '-target': projectTarget = validateTarget(args[i+1]);
				case '-help': showHelp();
				
				// default : trace ("case '"+temp+"': trace ('"+temp+"');");
			}
		}

		if (!isFolderSet){
			trace('Sorry I need a folder to export to');
			showHelp();
			return;
		}

		Sys.println('HxGenerate :: start');

		showSettings();
			
		createFolder(sanitize(projectName));
		createFolder(sanitize(projectName)+'/bin');
		createFolder(sanitize(projectName)+'/src');
		
		createHx(sanitize(projectName)+'/src','Main.hx');
		createIndex(sanitize(projectName)+'/bin','index.html');
		createHxml(sanitize(projectName),'build.hxml');
		createPackage(sanitize(projectName),'package.json');
		createReadme(sanitize(projectName),'README.MD');
		createBuild(sanitize(projectName),'BUILD.MD');
		createGitignore(sanitize(projectName),'.gitignore');
		
		storeDefault();
		
		Sys.println('HxGenerate :: done');
	}
	

	public function validateTarget (target:String) : String {
		return target;
	}
	
	private function readConfig() : Void
	{
		var folder = Sys.getCwd();
		var json : HxGenConfig;
		if (sys.FileSystem.exists(folder + 'hxgenerate.json')) {
			var str = (sys.io.File.getContent(folder +  'hxgenerate.json'));
			json = haxe.Json.parse(str);
		
			projectFolder = json.folder;
			projectTarget = json.target;
			projectName = json.name;
			projectAuthor  = json.author;
			projectLicense = json.license;
		} else {
			Sys.println('ERROR: can\'t find the config (${folder}hxgenerate.json)');
		}
		
	}
	
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

	private function showSettings() : Void
	{
		Sys.println('------------------

projectFolder : ${projectFolder}${sanitize(projectName)}
projectTarget : ${projectTarget} 
projectName : ${projectName} 
projectAuthor : ${projectAuthor} 
projectLicense : ${projectLicense} 

------------------');
	}
	
	private function sanitize(str:String) : String
	{
		return str.replace(' ', '_').replace(':', '').replace('/','').toLowerCase();
	}
	
	
	private function showHelp () : Void {
		Sys.println('

HX-GENERATE

how to use: 
hxgenerate -cd \'path/to/folder\' -name \'awsome project\' -license \'none\' -author \'that would be you\' -target \'neko\'

	-help : show this help
	-cd or -folder : path to project folder 
	-name : project Name (name also used for the name of the generate folder)
	-license : project license (MIT, etc)
	-author : project author (you?)
	-target : project target (js, cpp, flash, neko, etc)		
		
');
	}

	private function createHx(path:String, name:String) : Void
	{
		var str = 'package;
		
/**
 * @author ${projectAuthor}
 */	
class Main {
	
	public function new () {
		trace( "Hello ${projectName}" );
	}

	static public function main () {
		var app = new Main ();
	}
}';

		writeFile(path, name, str);
		Sys.println('\tcreate createHx');
	}
	
	private function createIndex(path:String, name:String) : Void
	{
		var str = '<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
	
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="favicon.ico">
	
	<title>${projectName}</title>
	
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
	
	<!-- custom css -->
	<link rel="stylesheet" href="${sanitize(projectName)}.css" >

</head>
<body>
	 <h1>Hello, world!</h1>

    <!-- jQuery (necessary for Bootstrap\'s JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
	<!-- Latest compiled and minified JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
	<!-- Code generated using Haxe -->
	<script type="text/javascript" src="${sanitize(projectName)}.js"></script>
</body>
</html>';

		writeFile(path, name, str);
		Sys.println('\tcreate createIndex');
	}
	
	private function createHxml(path:String, name:String) : Void
	{
		var str = '#libs
# -lib markdown
		
#integrate files to classpath
-cp src

#this class wil be used as entry point for your app.
-main Main

#neko target
-${projectTarget} bin/${sanitize(projectName)}.${projectTarget}

#Add debug information
-debug

# resources like templates
# -resource src/assets/LICENSE@licence

#dead code elimination : remove unused code
#"-dce no" : do not remove unused code
#"-dce std" : remove unused code in the std lib (default)
#"-dce full" : remove all unused code
-dce full

#Additional commandline stuff can be here
# -cmd neko bin/${projectName}.n
# -cmd open -a Google\\ Chrome http://localhost:2000/
';

		writeFile(path, name, str);
		Sys.println('\tcreate createHxml');
	}
	private function createPackage(path:String, name:String) : Void
	{
		var str = '{
	"license": "${projectLicense}",
	"name": "${projectName}",
	"version": "1.0.0",
	"description": "",
	"private": true,
	"author": "${projectAuthor}",
	"scripts": {
		"prewatch": "haxe build.hxml",
		"watch": "onchange \'src/*.hx\' \'src/*/*.hx\' -v -- haxe build.hxml"
	},
	"devDependencies": {
		"livereload": "0.4.1",
		"onchange": "2.0.0"
	}
}';

		writeFile(path, name, str);
		Sys.println('\tcreate createPackage');
	}
	
	private function createReadme(path:String, name:String) : Void
	{
		var str = '#${projectName}

- project target: ${projectTarget}
- project folder: ${projectFolder}${sanitize(projectName)}
- project author: ${projectAuthor}
- project license: ${projectLicense}
	
';

		writeFile(path, name, str);
		Sys.println('\tcreate createReadme');
	}

	private function createBuild(path:String, name:String) : Void
	{
		var str = '#Build ${projectName}

Default methode to build this file
		
```
cd \'${projectFolder}${sanitize(projectName)}\'
haxe build.hxml
echo done

```

#Build ${projectName} and start nekoserver and browser

Same as previous, but also start nekoserver and open Google Chrome browser.  

Great for testing js 
> Cross origin requests are only supported for protocol schemes: http, data, chrome, chrome-extension, https, chrome-extension-resource.

```

cd \'${projectFolder}${sanitize(projectName)}\'
haxe build.hxml
open -a Google\\ Chrome http://localhost:2000/
nekotools server


```

#Build ${projectName} using NPM watch

```

cd \'${projectFolder}${sanitize(projectName)}\'
npm run watch

```

';

		writeFile(path, name, str);
		Sys.println('\tcreate createBuild');
	}
	
	public function createGitignore (path:String, name:String) : Void {
		var str = 'BUILD.MD
.DS_Store
';

		writeFile(path, name, str);
		Sys.println('\tcreate createGitignore');
	}
	
	private function storeDefault() : Void
	{
		var temp : HxGenConfig = 
		{
			folder : projectFolder,
			target : projectTarget,
			name : projectName,
			author : projectAuthor,
			license : projectLicense
		}
		
		writeFile('../','hxgenerate.json',haxe.Json.stringify(temp));	
		Sys.println('\tcreate config');
	}
	
	
	
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
}