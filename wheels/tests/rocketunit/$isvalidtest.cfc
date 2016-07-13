<cfscript>
component extends="wheelsMapping.Test" {

	function setup() {
		loc.rocketUnit = CreateObject("component", "wheelsMapping.rocketunit.Test");
	}

	function test_package_is_valid() {
		assert('loc.rocketUnit.$isValidTest("wheelsMapping.tests._assets.rocketunit.ValidTestPackage")');
	}

	function test_package_is_invalid() {
		assert('! loc.rocketUnit.$isValidTest("wheelsMapping.tests._assets.rocketunit.ValidTestPackage", "Foo")');
	}
}
</cfscript>
