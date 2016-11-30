package gen.main;

using StringTools;

class MainNode extends MainBase implements IMainBase {

	public function new() {
		super();
		init();
	}

	function init ()
	{
		_import =
'
import js.Node.*
import js.Node;
import js.Node.console;

import js.node.Fs;
import js.node.Path;
import js.node.Require;

import js.npm.Express;
import js.npm.express.*;
import js.npm.SocketIo;

import model.constants.App;

using StringTools;

';

		_vars =
'
	var app : Dynamic;
	var server : Dynamic;
	var io : Dynamic;
';

		_func =
'
	function init () {

		console.log(\'init :: build: $${App.BUILD} \');

		var port = Sys.getEnv("PORT");
		// if(port == null) port = AppConstants.PORT;

		app    = new js.npm.Express();
		server = js.node.Http.createServer( cast app );
		io     = new js.npm.socketio.Server(server);

		app.use(new Favicon(Node.__dirname + \'/public/favicon.gif\'));

		app.get( \'/\' , function (req, res) {
			res.send(\'Welcome to the Node.js server\');
		});

		io.on( \'connection\' , function (socket) {
			socket.emit( \'message\' , { message: \'Welcome from the Node.js server\' });
			socket.on( \'send\' , function (data) {
				io.sockets.emit(\'id\', data.id);
				trace(\'send data -> \' + data.id);
			});
		});

		server.listen(port);
		trace(\'Listening on $$port\');
	}

	function loadData(){
		var req = new haxe.Http(\'merge_data_array.json\');
		// req.setHeader(\'Content-Type\', \'application/json\');
		// req.setHeader(\'auth\', \'$${App.TOKEN}\');
		req.onData = function (data : String) {
			try {
				var json = haxe.Json.parse(data);
				trace (json);
				saveFile(\'test.json\', haxe.Json.stringify(data));
			} catch (e:Dynamic){
				trace(e);
			}
		}
		req.onError = function (error : String) {
			trace(\'error: $$error\');
		}
		req.onStatus = function (status : Int) {
			trace(\'status: $$status\');
		}
		req.request(true);  // false=GET, true=POST
	}

	function saveFile(filename:String,str:String) {
		sys.io.File.saveContent( Node.__dirname +  \'/_data/$${filename}\', str);
	}

';

	}

	// override public function template() : String
	// {
	// 	return baseTemplate.replace(IMPORT,import).replace(VARS, vars).replace(FUNC, func);
	// }

}