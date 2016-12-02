component extends="wheels.tests.Test" {
	function test_automatic_label_ending_with_id() {
		_controller = controller(name="Cities");
		textField = _controller.textField(objectName="city", property="countyId");
		assert('textField contains "County"');
		assert('not textField contains "County Id"')
	}

	function test_override_value() {
		_controller = controller(name="ControllerWithModel");
		textField = _controller.textField(label="First Name", objectName="user", property="firstName", value="override");
		foundValue = YesNoFormat(FindNoCase('value="override"', textField));
		assert('foundValue eq true');
	}

	function test_maxlength_textfield_valid() {
		_controller = controller(name="ControllerWithModel");
		textField = _controller.textField(label="First Name", objectName="user", property="firstName");
		foundMaxLength = YesNoFormat(FindNoCase('maxlength="50"', textField));
		assert('foundMaxLength eq true');
	}
}
