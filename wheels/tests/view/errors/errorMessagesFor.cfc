component extends="wheels.tests.Test" {

	function setup() {
		_controller = controller(name = "ControllerWithModelErrors");
		args = {};
		args.objectName = "user";
		args.class = "errors-found";
	}

	function test_show_duplicate_errors() {
		args.showDuplicates = true;
		e = _controller.errorMessagesFor(argumentcollection = args);
		r = '<ul class="errors-found"><li>firstname error1</li><li>firstname error2</li><li>firstname error2</li></ul>';
		assert("e eq r");
	}

	function test_do_not_show_duplicate_errors() {
		args.showDuplicates = false;
		e = _controller.errorMessagesFor(argumentcollection = args);
		r = '<ul class="errors-found"><li>firstname error1</li><li>firstname error2</li></ul>';
		assert("e eq r");
	}

	function test_show_association_errors() {
		_nestedController = controller(name = "ControllerWithNestedModelErrors");
		args.showDuplicates = false;
		args.includeAssociations = true;
		actual = _nestedController.errorMessagesFor(argumentcollection = args);
		expected = '<ul class="errors-found"><li>firstname error1</li><li>lastname error1</li><li>age error1</li></ul>';
		assert("actual eq expected");
	}

}
