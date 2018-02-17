package;

import js.Node;
import js.node.Path;

import js.npm.Express;
import js.npm.express.*;

import server.Router;

class MainServer {

	public static inline var PORT = 3000;

	public static var io:js.npm.socketio.Server;

	public function new()
	{
		trace('Node.js rest-api: open browser at http://localhost:${PORT}');
		trace('Stop node.js : CTRL + c');

		var app : Express   = new Express();
		var server = js.node.Http.createServer( cast app );
        io = new js.npm.socketio.Server(server);

		// all environments
		app.set('port', PORT);
		app.use(new Favicon(Node.__dirname + '/public/favicon.ico'));
		app.use(new Morgan('dev'));
		app.use(BodyParser.json()); 							// support json encoded bodies
		app.use(BodyParser.urlencoded({ extended: true })); 	// support encoded bodies
		app.use(new Static(Path.join(Node.__dirname, 'public')));

		// Routes
		Router.init(app);

		app.use(function(req, res, next) {
			res.status(404).send('404');
			// res.status(404).send(output);
		});


		io.on('connection', function (socket) {
            socket.emit('message', { message: 'welcome to the chat' });
            socket.on('send', function (data) {
                io.sockets.emit('message', data);
            });
        });


		server.listen(PORT);

		// app.listen(app.get('port'), function(){
		// 	trace('Express server listening on port ' + app.get('port'));
		// });


	}

	static public function main () {
		new MainServer ();
	}
}