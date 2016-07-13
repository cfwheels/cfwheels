<cfscript>
component extends="wheels.Test" {

	function test_package_is_valid() {
		assert('$isValidTest("wheels.Tests._assets.testframework.ValidTestPackage")');
	}

	function test_package_is_invalid() {
		assert('! $isValidTest("wheels.Tests._assets.testframework.ValidTestPackage", "Foo")');
	}
}
</cfscript>
