component extends="wheels.tests.Test" {

	function setup() {
	  loc.controller = controller(name="dummy");
	}

	public void function test_clearing_cachable_actions() {
		loc.controller.caches(action="dummy");
		loc.controller.$clearCachableActions();
		loc.r = loc.controller.$cachableActions();
		assert("ArrayLen(loc.r) IS 0");
	}
}
