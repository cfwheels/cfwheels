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

	function test_attributes() {
		actual = _controller.buttonTo(class="form-class", inputClass="input-class", confirm="confirm-value", disable="disable-value");
		expected = '<form action="#application.wheels.webpath#" class="form-class" confirm="confirm-value" disable="disable-value" method="post"><input class="input-class" type="submit" value="" /></form>';
		assert('actual eq expected');
	}

}
