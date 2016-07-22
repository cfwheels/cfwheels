component extends="wheels.tests.Test" {

	function test_$isCoreFile_rewrite_cfm_is_true() {
		loc.path = ExpandPath('rewrite.cfm');
		debug("loc.path", false);
		assert("$isCoreFile(loc.path)", "loc.path");
	}

	function test_$isCoreFile_index_cfm_is_false() {
		loc.path = ExpandPath('index.cfm');
		debug("loc.path", false);
		assert("$isCoreFile(loc.path)", "loc.path");
	}

	function test_$isCoreFile_Dispatch_cfc_is_false() {
		loc.path = ExpandPath('wheels/Dispatch.cfc');
		debug("loc.path", false);
		assert("$isCoreFile(loc.path)", "loc.path");
	}

	function test_$isCoreFile_config_settings_cfm_is_false() {
		loc.path = ExpandPath('config/settings.cfm');
		debug("loc.path", false);
		assert("!$isCoreFile(loc.path)", "loc.path");
	}
}
