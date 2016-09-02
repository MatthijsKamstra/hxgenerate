package view.admin;

import model.AppConstants;
import AST;
import vo.PulseVO;
import vo.HermanBroodVO;
import view.talk.DirectMessageView;
import view.talk.MessageView;

import sys.io.File;
import sys.io.FileOutput;
import sys.FileSystem; 

class Pulse extends BaseView
{
	/*
	- maandag vanaf 8:00 een overzicht van de week
		- lijstje tonen
		- genereren van foto lijstje
	- ma t/m vr vanaf 8:00 een direct message aan degene die de dag eten moet halen
	- ma t/m vr vanaf 11:00 een overzicht van de boodschappen naar degene die eten moet halen
	- vr 17:00 biertijd
	 
	*/
	
	/*
	today // check of dag reset is van toepassing
	isMonday // eerst message in `herman-brood` channel
	isMorningNotification // morning direct-message user
	isLunchNotification // boodschappenlijst direct-message user
	isBeer // vrijdag 1700 uur notificatie
	*/


	private var pulseVO : PulseVO;

	public function new(d:haxe.web.Dispatch) 
	{				
		super();
		init();

		var _out = '';

		var date:Date  = Date.now();
		var currentString = utils.DateUtil.today(date);
		var day = date.getDay (); // the day of the week of this Date (0-6 range).
		var hour = date.getHours(); // (0-23 range).
		var min = date.getMinutes(); // (0-59 range).

		if(pulseVO.today != currentString) {
			resetPulse();
		}
		
		
		if(AppConstants.DEBUG){
			_out += '\n'+( "## debug\n" );
			resetPulse();
		}
		
		// sunday = 0
		// monday = 1;
		// tuesday = 2;
		// wednesday = 3; 
		// thursday = 4;
		// friday = 5
		// saterday = 6
		
		// [mck] php server
		_out += '\n'+('date: $date / day: $day / hour: $hour / min: $min');

		var isWorkingDay = false;
		if(day>=1 && day <=5) isWorkingDay = true;

		
		// monday 
		if(day == 1  && hour >= 7 && min > 0 && pulseVO.isMonday == false){
			_out += '\n'+('monday morning message\n');
			
			// var tt = new view.admin.MessageView("hallo @here, deze week gaan deze helden on helpen met het brood");
			var flf = new view.FonkLunchFeedback();
			var str = flf.getCalendar();
			  
			var json : view.talk.MessageView.MesssageAttachments = {
				fallback : "",
				color : "#FFD000",
				pretext : "Hallo @here, deze week gaan deze helden ons voorzien van brood:",
				// text : '${_feedback.text}',
				text : '$str',
				// mrkdwn : true 
			};
			 
			var tt = new MessageView("",json);
						
			pulseVO.isMonday = true;
			writeData(haxe.Json.stringify(pulseVO));
		} 

		if(hour >= 7 && min > 0 && pulseVO.isMorningNotification == false)
		{
			_out += '\n'+('send message to brood haler\n');
			var vo = view.FonkLunchFeedback.getCurrentUserVO();

			var dm = new DirectMessageView();
			dm.sendMessage(vo.id, 'Hi @${vo.name},\neen vriendelijke herinnering: vandaag zou jij brood moeten halen.\nKan je vandaag niet, kijk dan even op #herman-brood of je kan wisselen met iemand anders.');
			
			pulseVO.isMorningNotification = true;
			writeData(haxe.Json.stringify(pulseVO));
		} 

		if(hour >= 11 && min > 45 && pulseVO.isLunchNotification == false){
			_out += '\n'+('send message boodschappenlijst\n');
			
			var vo = view.FonkLunchFeedback.getCurrentUserVO();
			var list = view.FonkLunchFeedback.getGroceryList();
			
			if(list.length != 0){
				var dm = new DirectMessageView();
				dm.sendMessage(vo.id, 'Hi @${vo.name},\nnog een vriendelijke herinnering: vandaag zou jij brood moeten halen.\nMomenteel is dit de boodschappenlijst:\n' + list );
			}
			
			pulseVO.isLunchNotification = true;
			writeData(haxe.Json.stringify(pulseVO));
		} 
		

		_out += '\n'+('isWorkingDay:$isWorkingDay // hour:$hour // min:$min // isTimesheetNotification:${pulseVO.isTimesheetNotification}');


		// // timesheet actions
		// if(isWorkingDay == true && hour >= 17 && min >= 15 && pulseVO.isTimesheetNotification == false)
		// {
		// 	if(AppConstants.DEBUG) 
		// 	{
		// 		var _out = '';
		// 		var map : Map<vo.HermanBroodVO, Float> = new view.admin.TimeSheet().getTimesheetList();
		// 		for (key in map.keys()) {
		// 			var hours = map.get(key);
		// 			var vo = key;
		// 			var now = Date.now();
		// 			if(vo.name == null) continue;
		// 			// _out += '<li>';
		// 			// _out += ('Hi @${vo.name}, het lijkt erop dat je vandaag ${now.getDate()}-${now.getMonth()+1}-${now.getFullYear()} (nog) te weinig (${hours}) uren hebt geschreven, zou je deze kunnen aanvullen?');
		// 			// _out += '</li>';

		// 			// http://www.emoji-cheat-sheet.com/
		// 			var slackVO = new vo.SlackVO();
		// 			slackVO.icon = "%3Apoop%3A";
		// 			slackVO.username = "Herman$$$";

		// 			var dm = new DirectMessageView();
		// 			dm.sendMessage(vo.id, 'Hi @${vo.name},\nhet lijkt erop dat je vandaag ${now.getDate()}-${now.getMonth()+1}-${now.getFullYear()} (nog) te weinig (${hours}) uren hebt geschreven, zou je deze kunnen aanvullen?', slackVO);

		// 		}	
		// 	}

		// 	pulseVO.isTimesheetNotification = true;
		// 	writeData(haxe.Json.stringify(pulseVO));
		// }
		
		// friday
		if(day == 5 && hour >= 16 && min > 0 && pulseVO.isBeer == false){
			var json : view.talk.MessageView.MesssageAttachments = {
				fallback : "",
				color : "#FFD000",
				pretext : "",
				text : "Biertijd!",
				image_url : "http://sciencevibe.com/wp-content/uploads/2016/01/BEER.jpg"
			};
			
			
			var tt = new MessageView("",json);

			_out += '\n'+('beer message\n');
			pulseVO.isBeer = true;
			writeData(haxe.Json.stringify(pulseVO)); 
		} 

		_out += '\n'+sys.io.File.getContent(AppConstants.PULSE);
		
		php.Lib.print(view.page.HtmlView.init("Pulse",_out,"",nav));
	}
	
	private function init() : Void
	{
		if (!sys.FileSystem.exists("_pulse")) sys.FileSystem.createDirectory("_pulse");
		if(!sys.FileSystem.exists(AppConstants.PULSE)){
			resetPulse();
		} else{	
			pulseVO = PulseVO.parseVO(haxe.Json.parse(sys.io.File.getContent(AppConstants.PULSE)));
		}
	}
	
	private function resetPulse() : Void
	{
		var vo = new PulseVO(); 
		vo.today = utils.DateUtil.today();
		writeData(haxe.Json.stringify(vo));
		pulseVO = PulseVO.parseVO(haxe.Json.parse(sys.io.File.getContent(AppConstants.PULSE)));
	}
	
	private function writeData(out:String) : Void
	{
		var f:FileOutput = File.write(AppConstants.PULSE,false);
		f.writeString((out));
		f.close();
	}

}