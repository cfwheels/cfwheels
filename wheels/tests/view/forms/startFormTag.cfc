component extends="wheels.tests.Test" {

	function setup() {
		_controller = controller(name="dummy");
		args= {};
		args.host = "";
		args.method = "post";
		args.multipart = false;
		args.onlypath = true;
		args.port = 0;
		args.protocol = "";
		args.spamprotection = false;
		args.controller = "testcontroller";
	}

	function test_no_controller_or_action_or_route_should_point_to_current_page() {
		structdelete(args, "controller");
		argsction = _controller.urlfor(argumentCollection=args);
		e = '<form action="#argsction#" method="post">';
		r = _controller.startFormTag(argumentcollection=args);
		assert('e eq r');
	}

	function test_with_controller() {
		argsction = _controller.urlfor(argumentCollection=args);
		e = '<form action="#argsction#" method="post">';
		r = _controller.startFormTag(argumentcollection=args);
		assert("e eq r", "testing this out");
	}

	function test_with_get_method() {
		args.method = "get";
		argsction = _controller.urlfor(argumentCollection=args);
		e = '<form action="#argsction#" method="get">';
		r = _controller.startFormTag(argumentcollection=args);
		assert("e eq r");
	}

	function test_with_multipart() {
		args.multipart = "true";
		argsction = _controller.urlfor(argumentCollection=args);
		e = _controller.startFormTag(argumentcollection=args);
		r = '<form action="#argsction#" enctype="multipart/form-data" method="post">';
		assert("e eq r");
	}

	function test_with_root_route() {
		args.route = "root";
		argsction = _controller.toXHTML(_controller.urlfor(argumentCollection=args));
		e = '<form action="#argsction#" method="post">';
		r = _controller.startFormTag(argumentcollection=args);
		assert("e eq r");
	}

	function test_external_link() {
		args.action = "https://www.cfwheels.com";
		args.multipart = true;
		e = '<form action="https://www.cfwheels.com" enctype="multipart/form-data" method="post">';
		r = _controller.startFormTag(argumentcollection=args);
		assert("e eq r");
	}

}
