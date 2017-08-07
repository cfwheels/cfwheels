component extends="wheels.tests.Test" {

	function setup() {
		_controller = controller(name="dummy");
		oldURLRewriting = application.wheels.URLRewriting;
		application.wheels.URLRewriting = "On";
		oldScriptName = request.cgi.script_name;
		request.cgi.script_name = "/rewrite.cfm";
		set(functionName="buttonTo", encode=false);
	}

	function teardown() {
		application.wheels.URLRewriting = oldURLRewriting;
		request.cgi.script_name = oldScriptName;
		set(functionName="buttonTo", encode=true);
	}

	function test_buttonto_inner_encoding() {
		actual = _controller.buttonTo(text="<Click>", class="form-class", inputClass="input class", confirm="confirm-value", disable="disable-value", encode=true);
		expected = '<form action="#application.wheels.webpath#" class="form-class" confirm="confirm-value" disable="disable-value" method="post"><input class="input&##x20;class" type="submit" value="&lt;Click&gt;">' & _controller.authenticityTokenField() & '</form>';
		assert('actual eq expected');
	}

	function test_buttonto_attributes() {
		actual = _controller.buttonTo(class="form-class", inputClass="input-class", confirm="confirm-value", disable="disable-value");
		expected = '<form action="#application.wheels.webpath#" class="form-class" confirm="confirm-value" disable="disable-value" method="post"><input class="input-class" type="submit" value="">' & _controller.authenticityTokenField() & '</form>';
		assert('actual eq expected');
	}

	function test_buttonto_with_delete_method_argument() {
		actual = _controller.buttonTo(method="delete");
		expected = '<form action="#application.wheels.webpath#" method="post"><input id="_method" name="_method" type="hidden" value="delete"><input type="submit" value="">' & _controller.authenticityTokenField() & '</form>';
		assert('actual eq expected');
	}

	function test_buttonto_with_put_method_argument() {
		actual = _controller.buttonTo(method="put");
		expected = '<form action="#application.wheels.webpath#" method="post"><input id="_method" name="_method" type="hidden" value="put"><input type="submit" value="">' & _controller.authenticityTokenField() & '</form>';
		assert('actual eq expected');
	}

	// why one would do this I don't know.. but this is how it should render
	function test_buttonto_with_get_method_argument() {
		actual = _controller.buttonTo(method="get");
		expected = '<form action="#application.wheels.webpath#" method="get"><input type="submit" value=""></form>';
		assert('actual eq expected');
	}

}
