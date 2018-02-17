package server;

import js.npm.Express;

class Router {

	public static function init(app : Express):Void
	{
		app.get('/', Controller.index);
		app.get('/test', Controller.test);
		app.get('/latest', Controller.latest);
		// app.get('/update', Controller.update);

	}
}