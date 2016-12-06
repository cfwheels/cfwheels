component extends="wheels.tests.Test" {
	function test_automatic_label_for_id_property() {
		_controller = controller(name="Galleries");
		textField = _controller.textField(objectName="gallery", property="id");
		assert("FindNoCase('ID', textField)");
	}

	function test_automatic_label_ending_with_id() {
		_controller = controller(name="Galleries");
		textField = _controller.textField(objectName="gallery", property="userId");
		assert('textField contains "User"');
		assert('not textField contains "User Id"');
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
