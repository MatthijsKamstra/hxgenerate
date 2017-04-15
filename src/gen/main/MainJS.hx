package gen.main;

using StringTools;

class MainJS extends MainBase implements IMainBase {

	public function new() {
		super();
		init();
	}

	function init ()
	{
		_import =
'
import js.Browser.*;
import js.Browser;
import js.html.*;

import model.constants.App;
';

		_vars =
'
	var document : js.html.HTMLDocument = js.Browser.document;
	var container : js.html.DivElement;
';

		_func =
'
	function init() {
		document.addEventListener("DOMContentLoaded", function(event) {
			console.log(\'Dom ready :: build: $${App.BUILD} \');

			// var container = document.getElementById("prop");
			// container.innerHTML = \'html\';

			initHTML();
			loadData();
		});
	}

	function initHTML () {
		container = document.createDivElement();
		container.id = "::sprojectName::";
		container.className = "container";
		document.body.appendChild(container);

		var h1 = document.createElement(\'h1\');
		h1.innerText = "::projectName::";
		container.appendChild(h1);
	}

	function loadData(){
		var url = \'http://ip.jsontest.com/\';
		var req = new haxe.Http(url);
		// req.setHeader(\'Content-Type\', \'application/json\');
		// req.setHeader(\'auth\', \'$${App.TOKEN}\');
		req.onData = function (data : String) {
			try {
				var json = haxe.Json.parse(data);
				trace (json);
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
';
	}

	// override public function template() : String
	// {
	// 	return baseTemplate.replace(IMPORT,import).replace(VARS, vars).replace(FUNC, func);
	// }

}