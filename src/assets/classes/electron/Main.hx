
import electron.main.App;
import electron.main.BrowserWindow;
import electron.CrashReporter;

import js.Node;
import js.npm.Express;


class Main {

	var mainServer = new MainServer();
	public var mainWindow : BrowserWindow = null;

	public function new(){

		var mainServer = new MainServer();

		// Report crashes to our server.
		CrashReporter.start({
			companyName : "MatthijsKamstra",
			submitURL : "https://github.com/MatthijsKamstra/project-chromecast/issues"
		});

		// Quit when all windows are closed.
		App.on( 'window_all_closed', function(e) {
			// On OS X it is common for applications and their menu bar
			// to stay active until the user quits explicitly with Cmd + Q
			if (Node.process.platform != 'darwin')
				App.quit();
		});

		// This method will be called when Electron has finished
		// initialization and is ready to create browser windows.
		App.on( 'ready', function(e) {

			// Create the browser window.
			mainWindow = new BrowserWindow({width: 1024, height: 768});

			// Emitted when the window is closed.
			mainWindow.on( closed, function() {
				if( js.Node.process.platform != 'darwin' )
					electron.main.App.quit();
				// Dereference the window object, usually you would store windows
				// in an array if your app supports multi windows, this is the time
				// when you should delete the corresponding element.
				mainWindow = null;
			});

			new MainMenu(this);

			// Open the DevTools.
			// mainWindow.webContents.openDevTools();

			mainWindow.loadURL('http://localhost:3000');

		});
	}

	static function main() {
		var app = new Main();
	}

}
