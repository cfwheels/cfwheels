component extends="wheels.tests.Test" {

	function test_ignoredColumns() {
		shop = model("shop").findOne();

		debug("shop.properties()", true);

		assert('StructKeyExists(shop, "isblackmarket") eq false');
	}

}
