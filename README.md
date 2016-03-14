#HxGenerate

I start a lots of little [Haxe](http://www.haxe.org) projects, and use HIDE to create them.  
Seem silly to open an unfinished editor and generate a folder structure I will open in Sublime Text or VSCode

I now generate Haxe project folders with HxGenerate.


## how to use:

```
neko hxgenerate -cd 'path/to/folder' -name 'awsome project' -license 'none' -author 'that would be you' -target 'neko'

	-help : show this help
	-cd or -folder : path to project folder
	-name : project Name (name also used for the name of the generate folder)
	-license : project license (MIT, etc)
	-author : project author (you?)
	-target : project target (js, cpp, flash, neko, etc)

```

