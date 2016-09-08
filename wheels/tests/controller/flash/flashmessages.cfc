component extends="wheels.tests.Test" {

	function setup() {
		include "setup.cfm";
	}

	function teardown() {
		include "teardown.cfm";
	}

	function test_normal_output() {
		run_normal_output();
		_controller.$setFlashStorage("cookie");
		run_normal_output();
	}

	function test_specific_key_only() {
		run_specific_key_only();
		_controller.$setFlashStorage("cookie");
		run_specific_key_only();
	}

	function test_passing_through_id() {
		run_passing_through_id();
		_controller.$setFlashStorage("cookie");
		run_passing_through_id();
	}

	function test_empty_flash() {
		run_empty_flash();
		_controller.$setFlashStorage("cookie");
		run_empty_flash();
	}

	function test_empty_flash_includeEmptyContainer() {
		run_empty_flash_includeEmptyContainer();
		_controller.$setFlashStorage("cookie");
		run_empty_flash_includeEmptyContainer();
	}

	function test_skipping_complex_values() {
		run_skipping_complex_values();
		_controller.$setFlashStorage("cookie");
		run_skipping_complex_values();
	}

	function test_control_order_via_keys_argument() {
		run_control_order_via_keys_argument();
		_controller.$setFlashStorage("cookie");
		run_control_order_via_keys_argument();
	}

	function test_casing_of_class_attribute() {
		run_casing_of_class_attribute();
		_controller.$setFlashStorage("cookie");
		run_casing_of_class_attribute();
	}

	function test_casing_of_class_attribute_mixed() {
		run_casing_of_class_attribute_mixed();
		_controller.$setFlashStorage("cookie");
		run_casing_of_class_attribute_mixed();
	}

	function test_casing_of_class_attribute_upper() {
		run_casing_of_class_attribute_upper();
		_controller.$setFlashStorage("cookie");
		run_casing_of_class_attribute_upper();
	}

	function test_setting_class() {
		run_setting_class();
		_controller.$setFlashStorage("cookie");
		run_setting_class();
	}

	/**
	* HELPERS
	*/

	function run_normal_output() {
		_controller.flashInsert(success="Congrats!");
		_controller.flashInsert(alert="Error!");
		actual = _controller.flashMessages();
		assert("actual IS '<div class=""flashMessages""><p class=""alertMessage"">Error!</p><p class=""successMessage"">Congrats!</p></div>'");
	}

	function run_specific_key_only() {
		_controller.flashInsert(success="Congrats!");
		_controller.flashInsert(alert="Error!");
		actual = _controller.flashMessages(key="alert");
		assert("actual IS '<div class=""flashMessages""><p class=""alertMessage"">Error!</p></div>'");
	}

	function run_passing_through_id() {
		_controller.flashInsert(success="Congrats!");
		actual = _controller.flashMessages(id="my-id");
		assert("actual Contains '<p class=""successMessage"">Congrats!</p>' AND actual Contains 'id=""my-id""'");
	}

	function run_empty_flash() {
		actual = _controller.flashMessages();
		assert("actual IS ''");
	}

	function run_empty_flash_includeEmptyContainer() {
		actual = _controller.flashMessages(includeEmptyContainer="true");
		assert("actual IS '<div class=""flashMessages""></div>'");
	}

	function run_skipping_complex_values() {
		_controller.flashInsert(success="Congrats!");
		arr = [];
		arr[1] = "test";
		_controller.flashInsert(alert=arr);
		actual = _controller.flashMessages();
		assert("actual IS '<div class=""flashMessages""><p class=""successMessage"">Congrats!</p></div>'");
	}

	function run_control_order_via_keys_argument() {
		_controller.flashInsert(success="Congrats!");
		_controller.flashInsert(alert="Error!");
		actual = _controller.flashMessages(keys="success,alert");
		assert("actual IS '<div class=""flashMessages""><p class=""successMessage"">Congrats!</p><p class=""alertMessage"">Error!</p></div>'");
		actual = _controller.flashMessages(keys="alert,success");
		assert("actual IS '<div class=""flashMessages""><p class=""alertMessage"">Error!</p><p class=""successMessage"">Congrats!</p></div>'");
	}

	function run_casing_of_class_attribute() {
 		_controller.flashInsert(something="");
		actual = _controller.flashMessages();
		if (application.wheels.serverName eq "Railo" and application.wheels.serverversion.startsWith("3.")) {
			expected = 'class="SOMETHINGMessage"';
		} else {
			expected = 'class="somethingMessage"';
		}
		assert('Find(expected, actual)');
		_controller.flashInsert(someThing="");
	}

	function run_casing_of_class_attribute_mixed() {
		/*
		https://jira.jboss.org/browse/RAILO-933
		note that a workaround for RAILO is to quote the arugment:
		controller.flashInsert("someThing"="");
		Just remember that this throws a compilation error in ACF
		 */
		_controller.flashInsert(someThing="");
		actual = _controller.flashMessages();
		actual = _controller.flashMessages();
		if (application.wheels.serverName eq "Railo" and application.wheels.serverversion.startsWith("3.")) {
			expected = 'class="SOMETHINGMessage"';
		} else {
			expected = 'class="someThingMessage"';
		}
		assert('Find(expected, actual)');
	}

	function run_casing_of_class_attribute_upper() {
		_controller.flashInsert(SOMETHING="");
		actual = _controller.flashMessages();
		expected = 'class="SOMETHINGMessage"';
		assert('Find(expected, expected)');
	}

	function run_setting_class() {
		_controller.flashInsert(success="test");
		actual = _controller.flashMessages(class="custom-class");
		expected = 'class="custom-class"';
		if (application.wheels.serverName eq "Railo" and application.wheels.serverversion.startsWith("3.")) {
			e2 = 'class="SUCCESSMessage"';
		} else {
			e2 = 'class="successMessage"';
		}
		assert('Find(expected, actual) AND Find(e2, actual)');
	}

}
