component extends="wheels.tests.Test" {

	function setup() {
	  loc.controller = controller(name="dummy");
	}

	function test_getting_cache_settings_for_action() {
		loc.controller.caches(action="dummy1", time=100);
		loc.r = loc.controller.$cacheSettingsForAction("dummy1");
		assert("loc.r.time IS 100");
	}
}
