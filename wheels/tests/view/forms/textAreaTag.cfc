component extends="wheels.tests.Test" {

	function setup() {
		_controller = controller(name="dummy");
	}

	function test_x_textAreaTag_valid() {
		_controller.textAreaTag(name="description");
	}

}
