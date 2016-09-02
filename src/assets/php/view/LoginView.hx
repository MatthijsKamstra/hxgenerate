package view;

import php.Lib;

import haxe.web.Dispatch;
import haxe.crypto.Sha1;


import view.admin.LockAndKey;

class LoginView 
{

	var pEmail:String;
	var pPassword:String;
	var isFailLogin:Bool;
	var lockandkey : LockAndKey;

	public function new(d:Dispatch, ?args)
	{
		lockandkey = new LockAndKey();

		isFailLogin = false;

		pEmail    = d.params.exists('email') ? d.params.get('email') : '';
		pPassword = d.params.exists('password') ? d.params.get('password') : '';

		var isLoginCorrect = lockandkey.check(pEmail, pPassword);

		if(isLoginCorrect){
			// trace( "Login correct" );
			php.Web.redirect('/currentcomplement/');
		} else {
			// trace( "Login FAIL" );
			isFailLogin = true;
		}
	}	

	public function login()
	{
		init();		
	}

	public function logout()
	{
		lockandkey.logout();
	}

	public function init()
	{
		var _failmessage : String = '';
		if (isFailLogin && pEmail != '' && pPassword != ''){
        	_failmessage  = '<div class="alert alert-danger">Try again, your login failed!</div>';
		}

		// http://haxe.org/doc/cross/template
		var _content = 
			'<form class="form-signin" role="form" action="/login" method="post">' + 
			_failmessage  +
        	'	<h2 class="form-signin-heading">Please sign in</h2>' + 
        	'	<input type="text" name= "email" id="email" class="form-control" placeholder="Email address" required autofocus '+
		#if debug
			'value = "I am Voiila" ' +	
		#end	
        	'>' + 
        	'	<input type="password" name="password" id="password" class="form-control" placeholder="Password" required ' + 
        #if debug
			'value = "let me in!" ' +	
		#end	
			'>' + 
        	'	<!--<label class="checkbox">' + 
          	'		<input type="checkbox" value="remember-me"> Remember me' + 
        	'	</label>-->' + 
        	'	<button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>' + 
			'<a href="/logout/">logout</a>'+
      		'</form>'+
			
		#if debug
			'<style type="text/css">body { padding-top: 50px; background-color: #ffffff; }</style>'+
		#else 
			'<style type="text/css">body { padding-top: 0px; background-color: #ffffff; }</style>'+
		#end	
			'';

		var _title:String = 'Login';

		var str 	= haxe.Resource.getString("bootstrap_basic");
		var t 		= new haxe.Template(str);
		var output 	= t.execute({ title : _title, content : _content, navigation:'', jsscript:''});

		php.Lib.print(output);
	}



}