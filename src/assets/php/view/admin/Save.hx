package view.admin;

import php.Lib;

import vo.UserVO;
import model.AppConstants;
import view.page.HtmlView;

import sys.io.File;
import sys.io.FileOutput;
import sys.FileSystem;

class Save {

	// vars
	var _id:String;
	var _path:String;
	var _action:String;
	var _quote:String;

	var _isChecked:Bool;


	public function new ( d:haxe.web.Dispatch, ?args : { id:String , ?ischecked:String, ?path : String , ?action : String } )
	{
		if( args != null ){
			if (args.id != "") {
				// trace( "args.id: " + args.id );
				_id = args.id;
			}
			if (args.path != "" ){
				// trace( "args.path: " + args.path );
				_path = args.path;
			}
			if (args.action != ""){
				// trace( "args.action: " + args.action );
				_action = args.action;
			}
			if(args.ischecked != null) {
				(args.ischecked == "[x]") ? _isChecked = false : _isChecked = true;
			}
		}


		var _title = 'save';
		var _content = '$_isChecked';

		var str = sys.io.File.getContent(AppConstants.USER_JSON);
		var arr : Array<UserVO> = UserVO.parse(str);

		var out : Array<UserVO> = [];

		for ( i in 0 ... arr.length ) {
			var vo : UserVO = arr[i];

			if(vo.id == _id){
				vo.available = _isChecked;
			}

			out.push (vo);

		}


		var f:FileOutput = File.write(AppConstants.USER_JSON,false);
		f.writeString(haxe.Json.stringify(out));
		f.close();


		php.Web.setHeader( 'Location' , '/manage/' );


		var _content = str;
		// Lib.print( view.page.HtmlView.init( _title, _content ) );
	}
}