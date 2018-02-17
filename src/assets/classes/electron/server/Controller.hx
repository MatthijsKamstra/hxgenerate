package server;

import js.Node;
import js.node.Fs;
import js.npm.express.*;

class Controller {

	public static function index(req:Request,res:Response) {
		res.sendfile(Node.__dirname + '/public/index.html');
	}

	public static function test(req:Request,res:Response) {
		res.sendfile(Node.__dirname + '/public/test.html');
	}

	public static function latest(req:Request,res:Response) {
		var _url = Node.__dirname +  '/_config/config.json';
		var config = haxe.Json.stringify(
			{"date":""}
		);
		if(sys.FileSystem.exists(_url)){
			config = Fs.readFileSync(_url, "utf8");
		} else {
			if(!sys.FileSystem.exists(Node.__dirname + '/_config')) sys.FileSystem.createDirectory(Node.__dirname + '/_config');
			sys.io.File.saveContent( _url , config );
		}
		res.send(config);
	}

}