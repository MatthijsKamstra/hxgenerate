package;

/**
 * @author Matthijs Kamstra aka[mck]
 * MIT
 *
 */
class Main {

	public function new () {
		trace( "Hello \'Example Java\'" );
		java.Lib.println('println');
		java.Lib.print('print');
	}

	static public function main () {
		var app = new Main ();
	}
}