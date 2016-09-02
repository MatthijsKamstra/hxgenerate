package view.admin;

import php.Lib;

import sys.io.File;
import sys.io.FileOutput;
import sys.FileSystem;


import view.page.HtmlView;
import vo.UserVO;
import model.AppConstants;
import externs.*;
import AST;


class UserList extends BaseView
{

	public function new()
	{
		super();
		init();
	}

	public function init()
	{
		var hashMap : Map<String, UserVO> = new Map();

		if (!sys.FileSystem.exists("_user")) sys.FileSystem.createDirectory("_user");
		if(sys.FileSystem.exists(AppConstants.USER_JSON )){
			var __arr : Array<UserVO> = UserVO.parse(sys.io.File.getContent(AppConstants.USER_JSON ));
			for ( i in 0 ... __arr.length ) {
				hashMap.set(__arr[i].id, __arr[i]);
			}
		} else {
			// create a list
		}

		// https://api.slack.com/methods/users.list
		var str = sys.io.File.getContent('https://slack.com/api/users.list?token='+AppConstants.SLACK_TOKEN_FONK+'&presence=1&pretty=1');

		var userlist : AST.UserList = haxe.Json.parse(str);

		var fonkActiveArr : Array<Dynamic> = [];
		var fonkNonArr : Array<Dynamic> = [];
		var fonkFriendArr : Array<Dynamic> = [];
		var output = '';
		var counter = 1;

		if(userlist.length != 0){

			for (i in 0 ... userlist.members.length) {
				var usertype : AST.UserType = userlist.members[i];

				if(usertype.deleted) continue;
				if(usertype.is_bot) continue;

				// if(usertype.id == 'U02B196F1') {fonkNonArr.push(usertype); continue;} // - Dirk Schluter - presence: away
				// if(usertype.id == 'U02534WFL') {fonkNonArr.push(usertype); continue;} // - Erik Jan Bijvank - presence: away
				// if(usertype.id == 'U0252SDTP') {fonkNonArr.push(usertype); continue;} // - Niels de Keizer - presence: active
				if(usertype.id == 'USLACKBOT') {fonkNonArr.push(usertype); continue;} // - slackbot - presence: null
				if(usertype.id == 'U0474959Y') {fonkNonArr.push(usertype); continue;} // - Ludo Briet - presence: active
				if(usertype.id == 'U02B1UTQT') {fonkNonArr.push(usertype); continue;} // - Jannis Nikoy - presence: away
				if(usertype.id == 'U07UH6EQZ') {fonkNonArr.push(usertype); continue;} // - Jordy Dings - presence: away
				// if(usertype.id == 'U091S4RMM') {fonkNonArr.push(usertype); continue;} // - Joia Buning - presence: away
				// if(usertype.id == 'U04GQTUCH') {fonkNonArr.push(usertype); continue;} // - Orkun Ayhan - presence: away
				// if(usertype.id == 'U09GFNYTB') {fonkNonArr.push(usertype); continue;} // - John van den Berg - presence: away


				if((usertype.profile.email.indexOf('fonk') != -1) || (usertype.profile.email == null))
				{
					fonkActiveArr.push (usertype);

					output += '<b>$counter</b> <img src="'+usertype.profile.image_24+'">' + usertype.name + '(${usertype.id}) - ';
					output += ((usertype.profile.first_name != null) ? usertype.profile.first_name : "") ;
					output += " ";
					output += ((usertype.profile.last_name != null) ? usertype.profile.last_name : "") ;
					output += ' - presence: ' + (usertype.presence);
					output += "<br>";

					counter++;
				} else {
					fonkFriendArr.push(usertype);
				}
			}

		}


		writeData('fonk-friend',fonkFriendArr);
		writeData('fonk-nonactive',fonkNonArr);
		writeData('fonk-active',fonkActiveArr);

		var arr : Array<vo.UserVO> = [];
		for ( i in 0 ... fonkActiveArr.length ) {
			var usertype : AST.UserType = fonkActiveArr[i];
			var vo = new vo.UserVO();
			vo.name = usertype.name;
			vo.id = usertype.id;

			// [mck] check for images, start with original, work my way down
			var temp = '';
			if(usertype.profile.image_original != null){
				temp = usertype.profile.image_original;
			} else if (usertype.profile.image_512 != null) {
				temp =usertype.profile.image_512;
			} else if (usertype.profile.image_1024 != null) {
				temp =usertype.profile.image_1024;
			} else if (usertype.profile.image_192 != null){
				temp =usertype.profile.image_192;
			} else if (usertype.profile.image_72 != null){
				temp =usertype.profile.image_72;
			}
			vo.image = temp;
			vo.color = usertype.color;
			// [mck] check if this id already exists, if yes, take that available
			vo.available = (hashMap.exists(usertype.id)) ? hashMap.get(usertype.id).available : true;
			vo.birthday = (hashMap.exists(usertype.id)) ? hashMap.get(usertype.id).birthday : null;
			vo.real_name = usertype.real_name;
			vo.first_name = usertype.profile.first_name;
			vo.last_name = usertype.profile.last_name;
			arr.push(vo);
		}

		// [mck] TODO create an update system, to overwrite without thinking!
		var f:FileOutput = File.write(AppConstants.USER_JSON ,false);
		// var f:FileOutput = File.append(_filePath,false);
		f.writeString( haxe.Json.stringify(arr));
		f.close();

		// Lib.print('$userlist');
		// Lib.print('$output');

		// php.Web.setHeader( 'Location' , '/manage/' );

		// Lib.print(HtmlView.init('test',output,''));
	}

	private function writeData(listname:String,data:Dynamic):Void
	{
   		var _path = Sys.getCwd() + '/_peeps/';
		// trace( "_path: " + _path );

		if(! sys.FileSystem.exists( _path ) ){
			sys.FileSystem.createDirectory( _path );
		}

		// check if it worked
		 if(!sys.FileSystem.exists(_path)){
		 	try {
    			throw "Error";
			} catch( msg : String ) {
				trace("Error occurred: " + msg);
			}
		}

		var _date = Date.now();
		var _fileName = listname + "-" + _date.toString() + ".json" ;

		var _filePath = _path + "" + _fileName;

        var f:FileOutput = File.write(_filePath,false);
        // var f:FileOutput = File.append(_filePath,false);
        f.writeString(haxe.Json.stringify(data));
        f.close();
	}


}


typedef Out = {
	var id : String; //U023BECGF",
	var name : String; //bobby",
	var color : String; //9f69e7",

	var profile : AST.UserTypeProfile; //
}

// typedef HermanBrood = {
// 	var vo : Array<vo.UserVO>;
// }