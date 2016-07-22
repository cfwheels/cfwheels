component extends="wheels.tests.Test" {

	function setup() {
	  loc.controller = controller(name="dummy");
	}

	function test_setting_cachable_actions() {
		loc.arr = [];
		loc.arr[1] = {};
		loc.arr[1].action = "dummy1";
		loc.arr[1].time = 10;
		loc.arr[1].static = true;
		loc.arr[2] = {};
		loc.arr[2].action = "dummy2";
		loc.arr[2].time = 10;
		loc.arr[2].static = true;
		loc.controller.$setCachableActions(loc.arr);
		loc.r = loc.controller.$cachableActions();
		assert("ArrayLen(loc.r) IS 2 AND loc.r[2].action IS 'dummy2'");
	}
}
