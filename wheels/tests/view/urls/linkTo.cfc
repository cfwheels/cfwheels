component extends="wheels.tests.Test" {

	function setup() {
		_controller = controller(name="dummy");
		oldURLRewriting = application.wheels.URLRewriting;
		application.wheels.URLRewriting = "On";
		oldScriptName = request.cgi.script_name;
		request.cgi.script_name = "/rewrite.cfm";
	}

	function teardown() {
		application.wheels.URLRewriting = oldURLRewriting;
		request.cgi.script_name = oldScriptName;
	}

	function test_ampersand_and_equals_sign_encoding() {
		e = '<a href="#application.wheels.webpath#x/x?a=cats%26dogs%3Dtrouble&amp;b=1">x</a>';
		r = _controller.linkTo(text="x", controller="x", action="x", params="a=cats%26dogs%3Dtrouble&b=1");
		assert('e eq r');
	}

	function test_controller_action_only() {
		e = '<a href="#application.wheels.webpath#account/logout">Log Out</a>';
		r = _controller.linkTo(text="Log Out", controller="account", action="logout");
		assert('e eq r');
	}

	function test_external_links() {
		e = '<a href="http://www.cfwheels.com">CFWheels</a>';
		r = _controller.linkTo(href="http://www.cfwheels.com", text="CFWheels");
		assert('e eq r');
	}

}
