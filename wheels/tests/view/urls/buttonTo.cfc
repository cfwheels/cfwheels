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

	function test_confirm_is_escaped() {
		e = '<form action="#application.wheels.webpath#" method="post" onsubmit="return confirm(''Mark as: \''Completed\''?'');"><input type="submit" value="" /></form>';
		r = _controller.buttonTo(confirm="Mark as: 'Completed'?");
		assert('e eq r');
	}

	function test_disabled_is_escaped() {
		e = '<form action="#application.wheels.webpath#" method="post"><input onclick="this.disabled=true;this.value=''Mark as: \''Completed\''?'';this.form.submit();" type="submit" value="" /></form>';
		r = _controller.buttonTo(disable="Mark as: 'Completed'?");
		assert('e eq r');
	}

	function test_attributes() {
		e = '<form action="#application.wheels.webpath#" class="form-class" method="post"><input class="input-class" type="submit" value="" /></form>';
		r = _controller.buttonTo(class="form-class", inputClass="input-class");
		assert('e eq r');
	}

}
