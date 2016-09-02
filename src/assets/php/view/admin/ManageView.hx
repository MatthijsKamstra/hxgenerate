package view.admin;

import php.Lib;
import view.page.HtmlView;


import model.AppConstants;
import vo.HermanBroodVO;

class ManageView extends BaseView{
	
	public function new () 
	{
		super();
				
		var _out : String = '';
		
		var str = sys.io.File.getContent(AppConstants.FONK_LIST_JSON);

		var arr : Array<HermanBroodVO> = HermanBroodVO.parse(str); 
		
		_out += '<table class="table table-striped">
		<thead>
		<tr>
		<th>#</th>
		<th>real_name</th>
		<th>name</th>
		<th>id</th>
		<th>color</th>
		<th>image</th>
		<th>available</th>
		</tr> 
		</thead>
		<tbody>';
		
		for ( i in 0 ... arr.length ) 
		{
			var vo : HermanBroodVO= arr[i];
			var name = (vo.real_name == "") ? vo.name : vo.real_name;
			var foto_msg =  StringTools.urlEncode('Heeee ${vo.first_name}, je gebruikt nog steeds de standaard profiel foto.... \n\n Saai!!!');
			var name_msg =  StringTools.urlEncode('Heeee ${name}, je naam en achternaam heb je nog niet ingevult, zou je dat willen doen voor mij?');
			
			var isChecked = '[ ]';
			var isIcon = '<span class="glyphicon glyphicon-remove" aria-hidden="true" style="font-size: 2em; color:red"></span>';
			if (vo.available) {
				isChecked = '[x]';
				isIcon = '<span class="glyphicon glyphicon-ok" aria-hidden="true" style="font-size: 2em; color:green"></span>';
			}
			
			_out += '<tr> 
			<th scope="row">${i+1}</th>';
			
			if(vo.real_name == ""){
				_out += '<td><a href="/direct/?userid=${vo.id}&message=$name_msg">${name}</a></td>';
			} else {
				_out += '<td>${name}</td>';
			}
			
			_out += '<td>${vo.name}</td>
			<td>${vo.id}</td>
			<td><span style="color:#${vo.color}">${vo.color}</span></td>
			<td><a href="/direct/?userid=${vo.id}&message=$foto_msg"><img src="${vo.image}" width="50px"></a></td>
			<td><!-- ${vo.available} -->
			<a href="/save/?id=${vo.id}&ischecked=$isChecked">$isIcon</a>
			
			</td>
			</tr>';
		}
		
	
		_out += '</tbody></table>';
		
	
		Lib.print(HtmlView.init('test',_out ,'', nav));
	
	}
}

