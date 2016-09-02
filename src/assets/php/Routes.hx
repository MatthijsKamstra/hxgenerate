package ;

import haxe.web.Dispatch;
import view.*;
import view.admin.*;
import view.talk.DirectMessageView;
import view.talk.MessageView;

#if sys
	import Sys.println;
	import Sys.print;
#else
	import haxe.Log.trace in println;
	import haxe.Log.trace in print;
#end

// http://haxe.org/manual/dispatch
// https://gist.github.com/jasononeil/5667079

class Routes {

	public function new() {}

	function doDefault( d:Dispatch, str:String ) {
		new HomeView(str);
	}

	private function doHome(d:Dispatch){
		doDefault(d,'');
	}



	private function doTest(type:String){
		doAdmin(type);
	}

	private function doAdmin(type:String){
		new AdminView (type);
	}

	private function doCurrentcomplement(){
		new CurrentComplement ();
	}


	private function doSave(d:Dispatch, ?args : { id : String , ?ischecked:String, ?path : String , ?action : String }){
		new Save(d,args);
	}

	// private function doDirect(d:Dispatch, ?args : {userid:String, message:String}){
	// 	new DirectMessageView (d,args);
	// }

	private function doApi(d:Dispatch){
		new Api(d);
	}

	// private function doPulse(d:Dispatch){
	// 	new Pulse(d);
	// }

	// private function doManage(d:Dispatch){
	// 	new ManageView();
	// }

	// private function doUpdate(d:Dispatch){
	// 	new FonkListView();
	// }

	private function doUserlist(d:Dispatch){
		// new FonkListView();
		new UserList();
	}

	private function doLogin( d:Dispatch ){ new LoginView (d).login(); }
	private function doLogout( d:Dispatch ){ new LoginView (d).logout(); }




}

