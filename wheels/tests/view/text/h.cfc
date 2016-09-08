component extends="wheels.tests.Test" {

	function setup() {
		_controller = controller(name="dummy");
		content = "<b>This ""is"" a test string & it should format properly</b>";
	}

	function test_should_escape_html_entities() {
		e = XMLFormat(content);
		r = "&lt;b&gt;This &quot;is&quot; a test string &amp; it should format properly&lt;/b&gt;";
		assert("e eq r");
	}

}
