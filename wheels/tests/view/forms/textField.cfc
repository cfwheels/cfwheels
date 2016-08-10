component extends="wheels.tests.Test" {

	function setup() {
		_controller = controller(name="ControllerWithModel");
	}

	function test_override_value() {
		textField = _controller.textField(label="First Name", objectName="user", property="firstName", value="override");
		foundValue = YesNoFormat(FindNoCase('value="override"', textField));
		assert('foundValue eq true');
	}

	function test_maxlength_textfield_valid() {
		textField = _controller.textField(label="First Name", objectName="user", property="firstName");
		foundMaxLength = YesNoFormat(FindNoCase('maxlength="50"', textField));
		assert('foundMaxLength eq true');
	}

}
