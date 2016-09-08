component extends="wheels.tests.Test" {

	function setup() {
		include "setup.cfm";
		params = {controller="dummy", action="dummy"};
		_controller = controller("dummy", params);
	}

	function teardown() {
		include "teardown.cfm";
	}

	function test_render_text() {
		_controller.renderText("OMG, look what I rendered!");
		assert("_controller.response() IS 'OMG, look what I rendered!'");
	}

}
