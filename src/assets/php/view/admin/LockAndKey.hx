package view.admin;

import php.Session;

import haxe.crypto.Sha1;

import model.constants.Pass;

class LockAndKey {

	/**
	 * init session
	 * 
	 * @example	
	 * 			var lockandkey = new LockAndKey();
	 *			lockandkey.start();
	 */ 
	public function new()
	{
		if(!Session.started) Session.start();
	}

	public function check (pEmail:String, pPassword:String):Bool
	{
		var sha = Sha1.encode(pEmail + pPassword);
		var isCorrect = false;
		
		for (i in 0...Pass.LIST.length ) 
		{
			if(Pass.LIST[i] == sha) {
				isCorrect = true;
				Session.set('login' , 'true');
				continue;
			}
		}
		return isCorrect;
	}

	public function start()
	{
		var loginVal = Session.get('login');
		if (loginVal != 'true'){
			Session.clear();
			php.Web.redirect('/login/');
			// php.Web.setReturnCode(402);
			Sys.exit(0);
		} else {
			// php.Web.redirect('/admin/');
			php.Web.setHeader('X-Frame-Options','SAMEORIGIN');
		}

	}

	public function logout()
	{
		Session.clear();
		php.Web.redirect('/');	
	}

}