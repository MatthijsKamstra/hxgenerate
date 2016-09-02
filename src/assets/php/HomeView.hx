package;

import php.Lib;
import view.page.HtmlView;

class HomeView
{
	public function new(str:String)
	{

		var _title  = "++";
		var _content = '<!-- <img src="img/compliment.jpg" class="img-responsive" alt="Brood">-->';
		_content +=
			'<style>
			html {
				background: url(img/compliment.jpg) no-repeat center center fixed;
				-webkit-background-size: cover;
				-moz-background-size: cover;
				-o-background-size: cover;
				background-size: cover;
			}
			</style>';

		Lib.print(HtmlView.init( _title, _content ) );
		// Lib.print( 'home: str: ' + str  );
	}

}