component extends="wheelsMapping.Test" {
	function setup() {
		loc.controller = controller(name="dummy");
		loc.args = {};
		loc.args.host = "";
		loc.args.method = "post";
		loc.args.multipart = false;
		loc.args.onlypath = true;
		loc.args.port = 0;
		loc.args.protocol = "";
		loc.args.spamprotection = false;
		loc.args.controller = "testcontroller";
	}

	function test_no_controller_or_action_or_route_should_point_to_current_page() {
		StructDelete(loc.args, "controller");
		loc.url = loc.controller.urlfor(argumentCollection=loc.args);
		loc.e = '<form action="#loc.url#" method="post">' & loc.controller.authenticityTokenField();
		loc.r = loc.controller.startFormTag(argumentcollection=loc.args);
		assert("loc.r is loc.e");
	}

	function test_with_controller() {
		loc.url = loc.controller.urlfor(argumentCollection=loc.args);
		loc.e = '<form action="#loc.url#" method="post">' & loc.controller.authenticityTokenField();
		loc.r = loc.controller.startFormTag(argumentcollection=loc.args);
		assert("loc.r is loc.e");
	}

	function test_with_get_method() {
		loc.args.method = "get";
		loc.url = loc.controller.urlfor(argumentCollection=loc.args);
		loc.e = '<form action="#loc.url#" method="get">';
		loc.r = loc.controller.startFormTag(argumentcollection=loc.args);
		assert("loc.r is loc.e");
	}

	// TODO: Change `method` back to `post` after integrating ColdRoute. Then also test for inclusion of `_method`
	// hidden field.
	function test_with_put_method() {
		loc.args.method = "put";
		loc.url = loc.controller.urlfor(argumentCollection=loc.args);
		loc.e = '<form action="#loc.url#" method="put">' & loc.controller.authenticityTokenField();
		loc.r = loc.controller.startFormTag(argumentcollection=loc.args);
		assert("loc.r is loc.e");
	}

	// TODO: Change `method` back to `post` after integrating ColdRoute. Then also test for inclusion of `_method`
	// hidden field.
	function test_with_patch_method() {
		loc.args.method = "patch";
		loc.url = loc.controller.urlfor(argumentCollection=loc.args);
		loc.e = '<form action="#loc.url#" method="patch">' & loc.controller.authenticityTokenField();
		loc.r = loc.controller.startFormTag(argumentcollection=loc.args);
		assert("loc.r is loc.e");
	}

	// TODO: Change `method` back to `post` after integrating ColdRoute. Then also test for inclusion of `_method`
	// hidden field.
	function test_with_delete_method() {
		loc.args.method = "delete";
		loc.url = loc.controller.urlfor(argumentCollection=loc.args);
		loc.e = '<form action="#loc.url#" method="delete">' & loc.controller.authenticityTokenField();
		loc.r = loc.controller.startFormTag(argumentcollection=loc.args);
		assert("loc.r is loc.e");
	}

	function test_with_multipart() {
		loc.args.multipart = true;
		loc.url = loc.controller.urlfor(argumentCollection=loc.args);
		loc.r = loc.controller.startFormTag(argumentcollection=loc.args);
		loc.e = '<form action="#loc.url#" enctype="multipart/form-data" method="post">' & loc.controller.authenticityTokenField();
		assert("loc.r is loc.e");
	}

	function test_with_spamProtection() {
		loc.args.spamProtection = "true";
		loc.args.action = "myaction";
		loc.url = loc.controller.toXHTML(loc.controller.urlfor(argumentCollection=loc.args));
		loc.e = '<form method="post" onsubmit="this.action=''#Left(loc.url, int((Len(loc.url)/2)))#''+''#Right(loc.url, Ceiling((Len(loc.url)/2)))#'';">' & loc.controller.authenticityTokenField();
		loc.r = loc.controller.startFormTag(argumentcollection=loc.args);
		assert("loc.r is loc.e");
	}

	function test_with_home_route() {
		loc.args.route = "home";
		loc.url = loc.controller.toXHTML(loc.controller.urlfor(argumentCollection=loc.args));
		loc.e = '<form action="#loc.url#" method="post">' & loc.controller.authenticityTokenField();
		loc.r = loc.controller.startFormTag(argumentcollection=loc.args);
		assert("loc.r is loc.e");
	}

	function test_external_link() {
		loc.args.action = "https://www.cfwheels.com";
		loc.args.multipart = true;
		loc.e = '<form action="https://www.cfwheels.com" enctype="multipart/form-data" method="post">' & loc.controller.authenticityTokenField();
		loc.r = loc.controller.startFormTag(argumentcollection=loc.args);
		assert("loc.r is loc.e");
	}
}
