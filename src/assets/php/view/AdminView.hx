package view;

import php.Lib;
  
import view.admin.*;
import view.*;
import view.talk.DirectMessageView;
import view.talk.MessageView;

import haxe.crypto.Sha1;

import haxe.web.Dispatch;

import model.AppConstants;

class AdminView extends BaseView
{

	private var map = [
					'token' => 'Ezt3NdaQobJy1qnYKkJRVFOY', 
					'team_id' => 'T09U80AMQ', 
					'team_domain' => 'matthijskamstra', 
					'service_id' => '9960581973', 
					'channel_id' => 'C09U7MZR9', 
					'channel_name' => 'general', 
					'timestamp' => '1441066445.000017', 
					'user_id' => 'U09U7RFDL', 
					'user_name' => 'matthijs', 
					'text' => '++ @kay because you are awesome', 
					'trigger_word' => '++' 

				];

/**
 * token=Ezt3NdaQobJy1qnYKkJRVFOY
team_id=T0001
team_domain=example
channel_id=C2147483705
channel_name=test
timestamp=1355517523.000005
user_id=U2147483697
user_name=Steve
text=googlebot: What is the air-speed velocity of an unladen swallow?
trigger_word=googlebot:
 */


	public function new(type:String)
	{
		super();
		
		// trace  ( '+ new() - args: ' + [ type ] );

		switch (type) {
			// case 'fonklist'			: new FonkListView();
			// case 'message'			: new MessageView("Broodje hamburger zou er wel in gaan!");
			// case 'directmessage'	: new DirectMessageView(null,{ userid:'U09U7RFDL', message:'Test dit vanaf de testpage, @matthijs in #herman-brood' });
			// case 'manage'			: new ManageView();
			// case 'gen'				: new GenerateList();
			// case 'pulse'			: new Pulse(null);
			case 'api'				: 
				new Api(new Dispatch('test.test', map) );
			case 'api-basic'			: 
				
				var nameArr = ['@kay', '@monster', '@test'];
				var discArr = ['omdat je zo lekker ruikt', 'eind baas', 'tof als een boormachine'];

				var n = nameArr[Std.random(nameArr.length)];
				var d = discArr[Std.random(discArr.length)];

				map.set('text','++ $n $d');
				new Api(new Dispatch('test.test', map) );
			case 'api-week'			: 
				map.set('text','++ weekoverzicht');
				new Api(new Dispatch('test.test', map) );
			case 'api-overzicht'			: 
				map.set('text','++ overzicht');
				new Api(new Dispatch('test.test', map) ); 

			default : init(); 
		}

	}

	public function init()
	{
		var sha : String = Sha1.encode('I am Voiila' + 'let me in!');
		// trace( "sha: " + sha );
		var isDebug = false;
		#if debug
			isDebug = true;	
		#end	
		

		var phpversion = untyped __php__("phpversion();");

		var _content = '';
		
		_content += '<p><h2>';
		_content += 'servertime: ${Date.now()}';
		_content += '</h2></p>';
		_content += '<hr>';
		_content += '<p><h2>';
		_content += 'phpversion: ${phpversion}';
		_content += '</h2></p>';
		_content += '<hr>';
		_content += '<h3>Settings</h3>';
		_content += '<p>';
		_content += '<br>compiler debug: ' + isDebug;
		_content += '<br>debug: ' + AppConstants.DEBUG;
		_content += '<br>version: ' + AppConstants.VERSION;
		_content += '<br>build: ' + AppConstants.BUILD;
		_content += '<br>sha: ' + sha;
		
		_content += '<!--' ;
		_content += '<hr>' ;
		
		
		// _content += '<br>token: ' + ((AppConstants.DEBUG) ? AppConstants.SLACK_TOKEN_MCK : AppConstants.SLACK_TOKEN);
		_content += '<br>token: ' + (AppConstants.SLACK_TOKEN);
		_content += '<br>channel: ' + ((AppConstants.DEBUG) ? AppConstants.DEBUG_BOT_CHANNEL : AppConstants.BOT_CHANNEL);
		_content += '<br>username: ' + ((AppConstants.DEBUG) ? AppConstants.DEBUG_BOT_USERNAME : AppConstants.BOT_USERNAME); 
		_content += '<br>icon: ' + ((AppConstants.DEBUG) ? AppConstants.DEBUG_BOT_ICON : AppConstants.BOT_ICON);
		
		_content += '-->' ;

		_content += '</p>';
		// _content += '<h3>onderzoek links</h3>';
		// _content += '<a href="/test/timesheet">timesheet</a><br>';
		// _content += '<a href="/test/fonklist">fonklist</a><br>';
		// _content += '<a href="/test/message">message</a><br>';
		// _content += '<a href="/test/directmessage">directmessage</a><br>';
		// _content += '<a href="/test/manage">manage</a><br>';
		// _content += '<a href="/test/gen">gen</a><br>';
		// _content += '<a href="/test/pulse">pulse</a><br>';
		// _content += '<hr>';
		// _content += '<a href="/test/api">api</a><br>';
		// _content += '<a href="/test/api-bood">api boodschappen</a><br>';
		// _content += '<a href="/test/api-add">api boodschappenlijst pindasaus</a><br>';
		// _content += '<a href="/test/api-overzicht">api overzicht</a><br>';


		



		_content += '<hr>';
		_content += '<p><div class="alert alert-danger" role="alert"><b>Don\'t use the links below, unless you know what you are doing...<br>Extra check: are Matthijs? No? then you don\'t know what you are doing!</b></div></p>';
		_content += '<hr>';
		_content += '<a href="/admin/api">api (admin)</a><br>';
		_content += '<a href="/admin/api-basic">api basic</a><br>';
		_content += '<a href="/admin/api-week">api week-overzicht</a><br>';
		_content += '<a href="/admin/api-overzicht">api total-overzicht</a><br>';
		_content += '<a href="/admin/api-help">api help</a><br>';
		_content += '<a href="/admin/api-version">api version</a><br>';

		_content += '</p>';

		
		var _title:String = 'Admin';

		Lib.print( view.page.HtmlView.init( _title, _content, '', nav ) );
	}


}