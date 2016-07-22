component extends="wheels.tests.Test" {

	function setup() {
		params = {controller="dummy", action="dummy"};
		loc.controller = controller("dummy", params);
	}


	function test_valid() {
		// Build filter chain through array - this is what we're testing
		myFilterChain = [
			{through="restrictAccess"},
			{through="isLoggedIn,checkIPAddress", except="home,login"},
			{type="after", through="logConversion", only="thankYou"}
		];
		loc.controller.setFilterChain(myFilterChain);
		filterChainSet = loc.controller.filterChain();
		// Undo test
		loc.controller.setFilterChain(ArrayNew(1));
		// Build filter chain through "normal" filters() function
		loc.controller.filters(through="restrictAccess");
		loc.controller.filters(through="isLoggedIn,checkIPAddress", except="home,login");
		loc.controller.filters(type="after", through="logConversion", only="thankYou");
		filterChainNormal = loc.controller.filterChain();
		// Undo test
		loc.controller.setFilterChain(ArrayNew(1));
		// Compare filter chains
		assert("ArrayLen(filterChainSet) eq ArrayLen(filterChainNormal)");
		assert("filterChainSet.equals(filterChainNormal)");
	}

}
