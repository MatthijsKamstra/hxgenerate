package view.admin;

import php.Lib;

import view.admin.*;

import vo.ComplementVO;

class CurrentComplement extends BaseView {

	private var _db : HaxeLow;

	public function new() {
		super();
		_db = model.DBModel.getDB();
		init();
	}

	public function init():Void {
		var _content = getCompleetList();
		var _title:String = 'Totale Week Overzicht';
		Lib.print( view.page.HtmlView.init( _title, _content, '', nav ) );
	}


	function getCompleetList():String {
		var str = '';

		var objects = _db.keyCol(ComplementVO, 'name');
		objects.sort(function(a:ComplementVO, b:ComplementVO):Int
			{
				if (a.complements.length > b.complements.length) return -1;
				if (a.complements.length < b.complements.length) return 1;
				return 0;
			}
		);
		for (i in 0 ... objects.length) {
			var vo = objects[i];
			var spelling = 'complimenten';
			if(vo.complements.length <= 1) spelling = 'compliment';
			str += '${i+1}. ${vo.name} heeft ${vo.complements.length} $spelling\n';
			for (j in 0 ... vo.complements.length) {
				var senderComplement : SenderComplement = vo.complements[j];
				str += '\t- "${senderComplement.reason}" van "${senderComplement.sender}" op ${senderComplement.date} \n';
			}
		}
		return '<pre>$str</pre>';
	}



}