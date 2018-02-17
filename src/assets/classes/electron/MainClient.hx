package;

import js.Browser;
import js.Browser.document;
import js.Browser.console;

import js.jquery.JQuery;


class MainClient {

	var localStorage : js.html.Storage;

	public function new () {
		trace('MainClient :: client.js');

		localStorage = js.Browser.getLocalStorage();

		new JQuery(document).ready ( function () {
			trace ("client.js document ready!");

			// init sockets
			var _socket = js.browser.SocketIo.connect('http://localhost:3000');
			// var _socket = js.browser.SocketIo.connect('http://localhost:${MainServer.PORT}');
			_socket.on('message', function (data) {
				console.info('message:' + haxe.Json.stringify(data) );
				// toggleThrobber(true);
			} ) ;
			_socket.on('loading', function (data) {
				// console.info('loading:' + haxe.Json.stringify(data) );
				// toggleThrobber(true);
			} ) ;

		});
	}

	static public function main () {
		new MainClient ();
	}
}