package view.admin;

import php.Lib;

import vo.HermanBroodVO;
import model.AppConstants;
import view.page.HtmlView;

import sys.io.File;
import sys.io.FileOutput;
import sys.FileSystem; 

class GenerateList extends BaseView {
	
	
	private var currentDate:Date = Date.now();
	private var counter:Int = 0;
	
	private var fonkpeeps : Array<HermanBroodVO>; 
	private var calendar : AST.JsonTwoHxDef; 
	
	public function new ()
	{
		super();
		
		fonkpeeps  = HermanBroodVO.parse(sys.io.File.getContent(AppConstants.FONK_LIST_JSON)); 
		
		var _str = '';
		
		if (!sys.FileSystem.exists(AppConstants.BREAD_LIST_JSON)){
			// _str += 'generate new list';
			counter = Math.round(fonkpeeps.length / 2);
			writeList (generateNewList()); 
		} else {
			// _str += 'update list';
			// _str += sys.io.File.getContent(AppConstants.BREAD_LIST_JSON);
			generateUpdatedList();
		}
		
		
		var _out = '';
		_out += '<table class="table table-striped">
		<thead>
		<tr>
		<th>Datum</th>
		<th>real_name</th>
		<th>image</th>
		<th>message</th>
		</tr> 
		</thead>
		<tbody>';
		
		for ( i in 0 ... calendar.who.length ) 
		{
			var vo : HermanBroodVO= vo.HermanBroodVO.parseVO(calendar.who[i].info);
			var name = (vo.real_name == "") ? vo.name : vo.real_name;
			var msg =  StringTools.urlEncode('vandaag (${calendar.who[i].date}) mag jij brood halen :smile:');
			var foto_msg =  StringTools.urlEncode('Heeee ${vo.first_name}, je gebruikt nog steeds de standaard profiel foto.... \n\n Saai!!!\n\n (Tip: If you ever need to change your name or profile information, you can do so by editing your profile here: https://fonk.slack.com/account/profile )');
			var name_msg =  StringTools.urlEncode('Heeee ${name}, je naam en achternaam heb je nog niet ingevult, zou je dat willen doen voor mij?');
			
			_out += '<tr>
			<th scope="row">${calendar.who[i].date}</th>
			<td>';
			if(vo.real_name == ""){
				_out += '<a href="/direct/?userid=${vo.id}&message=$name_msg">${name}</a>';
			} else {
				_out += '${name}';
			}
			_out += '</td>
			<td>
			<a href="/direct/?userid=${vo.id}&message=$foto_msg"><img src="${vo.image}" width="50px"></a>
			</td>
			<td>
			<a href="/direct/?userid=${vo.id}&message=$msg">send message</a>
			</td>
			</tr>';
		}
		
	
		_out += '</tbody>
		</table>';
		
		
		
		
		Lib.print(HtmlView.init('test',_out,'', nav));
		
	}
			
	private function generateUpdatedList():Void
	{
		var _id = '';
		var _calenderID = 0;
		
		calendar = haxe.Json.parse( sys.io.File.getContent(AppConstants.BREAD_LIST_JSON));

		for (i in 0...calendar.who.length) {
			
			if ( calendar.who[i].date == utils.DateUtil.today() ){
				_id =  calendar.who[i].info._id;
				_calenderID = i;
			}
		}

		for (i in 0...fonkpeeps.length) {
			if (fonkpeeps[i].id == _id){
				counter = i;
			}

		}

		// [mck] create a json based upon fonkpeeps_clean.json
		var array :Array<Dynamic> = [];

		// rebuild the week on wednesday, monday/tuesday/wednesday will stay the same the rest may vari		

		if( currentDate.getDay() >= 2){
			// [mck] forget current day, that will be added later in the loop
			for (i in 1...currentDate.getDay()) {
				var _who = calendar.who[_calenderID - i];
				array.unshift( _who );
			}
		}
		
		writeList(generateNewList(array));

		calendar = haxe.Json.parse( sys.io.File.getContent(AppConstants.BREAD_LIST_JSON));

		counter = 0;
	}

	
	
	private function generateNewList(?arr:Array<Dynamic>) : String 
	{
		var array = (arr == null) ? [] : arr;
		
		for (i in 0...300) 
		{
			var _date:Date = Date.fromTime (currentDate.getTime() + DateTools.days(i));
			var nr = _date.getDay(); // 0 sunday /1 monday

			var strDate = utils.DateUtil.today(_date);

			// [mck] exclude sunday/ saterday	
			if (_date.getDay() == 0) continue;
			if (_date.getDay() == 6) continue;

			while (!fonkpeeps[counter].available){
				counter++;
				if (counter >= fonkpeeps.length) counter = 0;
			}

			var obj:Dynamic = {};
			obj.date = strDate;
			obj.id = fonkpeeps[counter].id; 
			obj.info = fonkpeeps[counter]; 
			
			// [mck] for the json
			array.push (obj);

			counter++;

			if (counter >= fonkpeeps.length) counter = 0;
		}

		var obbj:Dynamic = {};
		obbj.created = utils.DateUtil.today();
		obbj.count = fonkpeeps.length + 1;
		obbj.who = array;
		
		var str : String = haxe.Json.stringify (obbj);
		return haxe.Json.stringify (obbj);

		// writeList();
	}
	
	
	
	private function writeList(str:String) : Void
	{
		var f:FileOutput = File.write(AppConstants.BREAD_LIST_JSON,false);
		f.writeString(str);
		f.close();
	}
	
	
}