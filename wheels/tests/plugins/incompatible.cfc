component extends="wheels.tests.Test" {

	include "helpers.cfm";

	function setup() {
		config = {
			path="wheels"
			,fileName="Plugins"
			,method="init"
			,pluginPath="/wheelsMapping/tests/_assets/plugins/standard"
			,deletePluginDirectories=false
			,overwritePlugins=false
			,loadIncompatiblePlugins=true
		};
	}

	function test_raise_incompatible_plugin() {
		config.pluginPath = "/wheelsMapping/tests/_assets/plugins/incompatible";
		actual = raised('$pluginObj(config)');
		expected = "Wheels.IncompatiblePlugin";
		assert('actual eq expected');
	}

}
