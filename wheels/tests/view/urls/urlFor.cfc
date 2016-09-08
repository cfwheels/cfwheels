component extends="wheels.tests.Test" {

	function setup(){
		params.controller = "Blog";
		params.action = "edit";
		params.key = "1";
		_controller = controller(params.controller, params);
		args = {};
		args.controller = "Blog";
		args.action = "edit";
		args.key = "1";
		args.params = "param1=foo&param2=bar";
		args.$URLRewriting = "On";
		oldScriptName = request.cgi.script_name;
	}

	function teardown(){
		request.cgi.script_name = oldScriptName;
	}

	function test_all_arguments_with_url_rewriting(){
		request.cgi.script_name = "/rewrite.cfm";
		e = "#application.wheels.webpath#blog/edit/1?param1=foo&param2=bar";
		r = _controller.urlFor(argumentcollection=args);
		assert("e eq r");
	}

	function test_missing_controller_with_url_rewriting(){
		request.cgi.script_name = "/rewrite.cfm";
		StructDelete(args, "controller");
		e = "#application.wheels.webpath#blog/edit/1?param1=foo&param2=bar";
		r = _controller.urlFor(argumentcollection=args);
		assert("e eq r");
	}

	function test_missing_action_with_url_rewriting(){
		request.cgi.script_name = "/rewrite.cfm";
		StructDelete(args, "action");
		e = "#application.wheels.webpath#blog/edit/1?param1=foo&param2=bar";
		r = _controller.urlFor(argumentcollection=args);
		assert("e eq r");
	}

	function test_missing_controller_and_action_with_url_rewriting(){
		request.cgi.script_name = "/rewrite.cfm";
		StructDelete(args, "controller");
		StructDelete(args, "action");
		e = "#application.wheels.webpath#blog/edit/1?param1=foo&param2=bar";
		r = _controller.urlFor(argumentcollection=args);
		assert("e eq r");
	}

	function test_all_arguments_without_url_rewriting(){
		request.cgi.script_name = "/index.cfm";
		args.$URLRewriting = "Off";
		webRoot = Replace("#application.wheels.webpath##ListLast(request.cgi.script_name, '/')#", "//", "/");
		e = "#webRoot#?controller=blog&action=edit&key=1&param1=foo&param2=bar";
		r = _controller.urlFor(argumentcollection=args);
		assert("e eq r");
	}

	function test_missing_controller_without_url_rewriting(){
		request.cgi.script_name = "/index.cfm";
		args.$URLRewriting = "Off";
		StructDelete(args, "controller");
		webRoot = Replace("#application.wheels.webpath##ListLast(request.cgi.script_name, '/')#", "//", "/");
		e = "#webRoot#?controller=blog&action=edit&key=1&param1=foo&param2=bar";
		r = _controller.urlFor(argumentcollection=args);
		assert("e eq r");
	}

	function test_missing_action_without_url_rewriting(){
		request.cgi.script_name = "/index.cfm";
		args.$URLRewriting = "Off";
		StructDelete(args, "action");
		webRoot = Replace("#application.wheels.webpath##ListLast(request.cgi.script_name, '/')#", "//", "/");
		e = "#webRoot#?controller=blog&action=edit&key=1&param1=foo&param2=bar";
		r = _controller.urlFor(argumentcollection=args);
		assert("e eq r");
	}

	function test_missing_controller_and_action_without_url_rewriting(){
		request.cgi.script_name = "/index.cfm";
		args.$URLRewriting = "Off";
		StructDelete(args, "controller");
		StructDelete(args, "action");
		webRoot = Replace("#application.wheels.webpath##ListLast(request.cgi.script_name, '/')#", "//", "/");
		e = "#webRoot#?controller=blog&action=edit&key=1&param1=foo&param2=bar";
		r = _controller.urlFor(argumentcollection=args);
		assert("e eq r");
	}
}
