component extends="wheels.tests.Test" {

	function setup() {
		include "setup.cfm";
		params = {controller="test", action="test"};
		_controller = controller("test", params);
	}

	function teardown() {
		include "teardown.cfm";
	}

	function test_rendering_current_action() {
		result = _controller.renderPage();
		assert("_controller.response() Contains 'view template content'");
	}

	function test_rendering_view_for_another_controller_and_action() {
		result = _controller.renderPage(controller="main", action="template");
		assert("_controller.response() Contains 'main controller template content'");
	}

	function test_rendering_view_for_another_action() {
		result = _controller.renderPage(action="template");
		assert("_controller.response() Contains 'specific template content'");
	}

	function test_rendering_specific_template() {
		result = _controller.renderPage(template="template");
		assert("_controller.response() Contains 'specific template content'");
	}

	function test_rendering_and_returning_as_string() {
		result = _controller.renderPage(returnAs="string");
		assert("NOT StructKeyExists(request.wheels, 'response') AND result Contains 'view template content'");
	}

}
