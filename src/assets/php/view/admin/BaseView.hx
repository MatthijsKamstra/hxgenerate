package view.admin;


import view.admin.LockAndKey;

class BaseView
{
	var lockandkey : LockAndKey;

	public var nav:String;

	public function new()
	{
		lockandkey = new LockAndKey();
		lockandkey.start();

		// nav = '
		// <nav class="navbar navbar-default">
		// 	<div class="container">
		// 		<ul class="nav navbar-nav">
		// 			<li><a href="/test/">TEST</a></li>
		// 			<li><a href="/update/">Update fonklist</a></li>
		// 			<li><a href="/manage/">Manage fonklist</a></li>
		// 			<li><a href="/gen/">Generate fonklist</a></li>
		// 			<li><a href="/timesheet/">Timesheet</a></li>
		// 	</div>
		// </nav>';


		nav = '
		<nav class="navbar navbar-default navbar-inverse">
			<div class="container">
				<ul class="nav navbar-nav">
					<li><a href="/"> Home </a></li>
					<li><a href="/admin/">Admin</a></li>
					<li><a href="/currentcomplement/">Complements</a></li>
					<li><a href="/userlist/">User List</a></li>
					<!--
					<li><a href="/update/">Update fonklist</a></li>
					<li><a href="/manage/">Manage fonklist</a></li>
					<li><a href="/gen/">Generate fonklist</a></li>
					-->
				</ul>
				<ul class="nav navbar-nav navbar-right">
					<li><a href="/logout">Logout</a></li>
					<!--
					<li class="dropdown">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Dropdown <span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="#">Action</a></li>
							<li><a href="#">Another action</a></li>
							<li><a href="#">Something else here</a></li>
							<li role="separator" class="divider"></li>
							<li><a href="#">Separated link</a></li>
						</ul>
					</li>
					-->
				</ul>

			</div><!-- /.container -->
		</nav>';

	}

}