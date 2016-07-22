component extends="wheels.tests.Test" {

	function setup(){
		loc.controller = controller(name="dummy");
		loc.user = model("users");
	}

	function test_x_pagination_valid(){
		loc.e = loc.user.findAll(where="firstname = 'somemoron'", perpage="2", page="1", handle="pagination_test_1", order="id");
		loc.controller.pagination("pagination_test_1");
	}
}
