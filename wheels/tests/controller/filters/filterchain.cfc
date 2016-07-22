component extends="wheels.tests.Test" {

	function setup() {
		params = {controller="dummy", action="dummy"};
		loc.controller = controller("dummy", params);
		loc.controller.before1 = before1;
		loc.controller.before2 = before2;
		loc.controller.before3 = before3;
		loc.controller.after1 = after1;
		loc.controller.after2 = after2;
	}


	function test_return_correct_type() {

		loc.controller.filters(through="before1", type="before");
		loc.controller.filters(through="before2", type="before");
		loc.controller.filters(through="before3", type="before");
		loc.controller.filters(through="after1", type="after");
		loc.controller.filters(through="after2", type="after");

		loc.before = loc.controller.filterChain("before");
		loc.after = loc.controller.filterChain("after");
		loc.all = loc.controller.filterChain();

		assert('ArrayLen(loc.before) eq 3');
		assert('loc.before[1].through eq "before1"');
		assert('loc.before[2].through eq "before2"');
		assert('loc.before[3].through eq "before3"');

		assert('ArrayLen(loc.after) eq 2');
		assert('loc.after[1].through eq "after1"');
		assert('loc.after[2].through eq "after2"');

		assert('ArrayLen(loc.all) eq 5');
	}

	function before1() {
		return "before1";
	}

	function before2() {
		return "before2";
	}

	function before3() {
		return "before3";
	}

	function after1() {
		return "after1";
	}

	function after2() {
		return "after2";
	}
}
