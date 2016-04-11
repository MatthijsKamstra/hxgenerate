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
	/**
	* 0.0.3 -x added, using haxe.template
	* 0.0.2 update all target, add more output nicities 
	* 0.0.1 initial 
	*/
	private var VERSION : String = '0.0.3';

	private var projectFolder 	: String = '';
	private var projectTarget 	: String = 'js';
	private var projectName 	: String = 'Foobar';
	private var projectAuthor 	: String = 'Matthijs Kamstra aka [mck]';
	private var projectLicense 	: String = 'MIT';
	private var projectWebsite 	: String = '';
	private var projectXType 	: String = '';
	
	private var targetArr : Array<String> = ["cpp", "js", "flash", "neko", "php", "cs", "java", "python"];
	
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
				case '-x': 					projectXType = validateXType(args[i+1]); isXperimental = true;
				
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
		createFolder(sanitize(projectName)+'/_build');
		
		createHx(sanitize(projectName)+'/src','Main.hx');
		if(projectTarget == 'js') createIndex(sanitize(projectName)+'/bin','index.html');
		createBuildTargets(sanitize(projectName)+'/_build');
		createHxml(sanitize(projectName),'build.hxml', projectTarget);
		createPackage(sanitize(projectName),'package.json');
		createReadme(sanitize(projectName),'README.MD');
		createBuild(sanitize(projectName),'BUILD.MD');
		createGitignore(sanitize(projectName),'.gitignore');
		
		writeConfig();
		
		if(isXperimental) createXperimental(projectXType);
		
		Sys.println('HxGenerate :: done');
	}
	
	// ____________________________________ validate ____________________________________

	public function validateTarget (target:String) : String 
	{
		var isValidTarget = false;
		for ( i in 0 ... targetArr.length ) {
			if(target == targetArr[i]) isValidTarget = true;
		}
		if(!isValidTarget) Sys.println('ERROR :: I don\'t know this target (${target}), must be an experimental');
		return target;
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
		return str.replace(' ', '_').replace(':', '').replace('/','').toLowerCase();
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

	// ____________________________________ create files ____________________________________
	
	private function createHx(path:String, name:String) : Void
	{
		createWithTemplate(path, name, "Main");
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
        var t = new haxe.Template(str);
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
		Sys.println('\tcreate template ${name}');
	}
	
	private function createIndex(path:String, name:String) : Void
	{
		createWithTemplate(path, name, "index");
		Sys.println('\tcreate $name');
	}
	
	private function createHxml(path:String, name:String, target:String, ?content:String) : Void
	{
		var str = '# Libraries you like to use (http://lib.haxe.org/)
# -lib markdown
# -lib svglib
# -lib jQueryExtern
		
# Integrate files to classpath
-cp src

# This class wil be used as entry point for your app.
-main Main

# ${target} target
';

// [mck] every target should have it's own export setting
switch (target) {
	case 'php': str += '-${target} bin/www';
	case 'cpp': str += '-${target} bin';
	case 'cs': str += '-${target} bin/${sanitize(projectName)}.exe';
	case 'java': str += '-${target} bin/java';// ${sanitize(projectName)}.jar';
	case 'flash': str += '-swf bin/${sanitize(projectName)}.swf';
	case 'neko': str += '-${target} bin/${sanitize(projectName)}.n';
	case 'python': str += '-${target} bin/${sanitize(projectName)}.py';
	case 'js': 
		str += '-${target} bin/${sanitize(projectName)}.js';
		str += '

# You can use -D source-map-content (requires Haxe 3.1+) to have the .hx 
# files directly embedded into the map file, this way you only have to 
# upload it, and it will be always in sync with the compiled .js even if 
# you modify your .hx files.
-D source-map-content

';
	default : str += '-${target} bin/${sanitize(projectName)}.${target}';
}


str += '

# Add debug information
-debug

# Resources like templates
# -resource src/assets/LICENSE@licence

# Dead code elimination : remove unused code
# "-dce no" : do not remove unused code
# "-dce std" : remove unused code in the std lib (default)
# "-dce full" : remove all unused code
-dce full

# Add extra targets
# --next

# Additional commandline actions can be done here
';


// [mck] every target should have it's own command settings
switch (target) {
	case 'java':
		str += '# run our application\n-cmd cd bin/java\n-cmd java -jar Main-Debug.jar\n';
	case 'js': 
		str += '# -cmd open -a Google\\ Chrome http://localhost:2000/\n';
		str += '# -cmd nekotools server';
	case 'php': 
		str += '# -cmd open -a Google\\ Chrome http://localhost:2000/\n';
	case 'neko': 
		str += '-cmd nekotools boot bin/${sanitize(projectName)}.n\n';
		str += '# -cmd ${target} bin/${sanitize(projectName)}.n\n';
	// default : str += '-${target} bin/${sanitize(projectName)}.${target}';
}
 
 
 		if(content != null) str = content; 
 
		writeFile(path, name, str);
		Sys.println('\t\tcreate ${target}.hxml');
	}
	
	
	function createBuildTargets (path:String)
	{
		Sys.println('\tcreate all buildtarget');
		for ( i in 0 ... targetArr.length ) {
			createHxml(path, '${targetArr[i]}.hxml', targetArr[i]);	
		}		
	}
	
	
	function createPackage(path:String, name:String) : Void
	{
		createWithTemplate(path, name, "package");
		Sys.println('\tcreate createPackage');
	}
	
	function createReadme(path:String, name:String) : Void
	{
		createWithTemplate(path, name, "readme");
		Sys.println('\tcreate createReadme');
	}

	function createBuild(path:String, name:String) : Void
	{
		var str = '#Build ${projectName}

Default methode to build this project
		
```
cd \'${projectFolder}${sanitize(projectName)}\'
haxe build.hxml
echo done

```
';

if(projectTarget == 'js'){
	str += '
#Build ${projectName} and start nekoserver and browser

Same as previous, but also start nekoserver and open Google Chrome browser.  

Great for testing js 
> Cross origin requests are only supported for protocol schemes: http, data, chrome, chrome-extension, https, chrome-extension-resource.

```
cd \'${projectFolder}${sanitize(projectName)}\'
haxe build.hxml
';

switch (projectTarget) {
	case 'java': str += 'cd \'${projectFolder}${sanitize(projectName)}/bin/java\'';
	case 'php': str += 'cd \'${projectFolder}${sanitize(projectName)}/bin/www\'';
	default : str += 'cd \'${projectFolder}${sanitize(projectName)}\'';
}

str += '
open -a Google\\ Chrome http://localhost:2000/
nekotools server

```
';
}
	str += '
#Build ${projectName} using NPM watch

```
cd \'${projectFolder}${sanitize(projectName)}\'
npm run watch

```

';

		writeFile(path, name, str);
		Sys.println('\tcreate createBuild');
	}
	
	// ignore some files I generate 
	function createGitignore (path:String, name:String) : Void 
	{
		var str = 'BUILD.MD\n.DS_Store\n';
		writeFile(path, name, str);
		Sys.println('\tcreate createGitignore');
	}
	
	function createXperimental(type:String) 
	{
		// [mck] should be a combination of project vs -x name
		switch (type.toLowerCase())
		{
			case 'test' : createWithTemplate(sanitize(projectName)+'/src','Test.hx', 'Class');
			case 'flux' : 
				createFolder(sanitize(projectName)+'/src/store');
				createWithTemplate(sanitize(projectName)+'/src/store','Store.hx', 'Singleton');
		}
	
		switch (projectTarget.toLowerCase()) 
		{
			case 'neko': 
				createWithTemplate(sanitize(projectName)+'/src','Main.hx', 'MainNeko');
				createWithTemplate(sanitize(projectName),'test.hxml', 'buildNeko');
			default : Sys.println('\tthere is no -x for ${projectTarget} yet!');
		}
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
HX-GENERATE

how to use: 
neko hxgenerate -cd \'path/to/folder\' -name \'awsome project\' -license \'none\' -author \'that would be you\' -target \'neko\'

	-help : show this help
	-cd or -folder : path to project folder 
	-name : project Name (name also used for the name of the generate folder)
	-license : project license (MIT, etc)
	-author : project author (you?)
	-website : project website (from you?)
	-target : project target (js, cpp, flash, neko, etc)		
		
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