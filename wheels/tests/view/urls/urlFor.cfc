component extends="wheels.tests.Test" {

	function setup(){
		params.controller = "Blog";
		params.action = "edit";
		params.key = "1";
		loc.controller = controller(params.controller, params);
		loc.args = {};
		loc.args.controller = "Blog";
		loc.args.action = "edit";
		loc.args.key = "1";
		loc.args.params = "param1=foo&param2=bar";
		loc.args.$URLRewriting = "On";
		oldScriptName = request.cgi.script_name;
	}

	function teardown(){
		request.cgi.script_name = oldScriptName;
	}

	function test_all_arguments_with_url_rewriting(){
		request.cgi.script_name = "/rewrite.cfm";
		loc.e = "#application.wheels.webpath#blog/edit/1?param1=foo&param2=bar";
		loc.r = loc.controller.urlFor(argumentcollection=loc.args);
		assert("loc.e eq loc.r");
	}

	function test_missing_controller_with_url_rewriting(){
		request.cgi.script_name = "/rewrite.cfm";
		StructDelete(loc.args, "controller");
		loc.e = "#application.wheels.webpath#blog/edit/1?param1=foo&param2=bar";
		loc.r = loc.controller.urlFor(argumentcollection=loc.args);
		assert("loc.e eq loc.r");
	}

	function test_missing_action_with_url_rewriting(){
		request.cgi.script_name = "/rewrite.cfm";
		StructDelete(loc.args, "action");
		loc.e = "#application.wheels.webpath#blog/edit/1?param1=foo&param2=bar";
		loc.r = loc.controller.urlFor(argumentcollection=loc.args);
		assert("loc.e eq loc.r");
	}

	function test_missing_controller_and_action_with_url_rewriting(){
		request.cgi.script_name = "/rewrite.cfm";
		StructDelete(loc.args, "controller");
		StructDelete(loc.args, "action");
		loc.e = "#application.wheels.webpath#blog/edit/1?param1=foo&param2=bar";
		loc.r = loc.controller.urlFor(argumentcollection=loc.args);
		assert("loc.e eq loc.r");
	}

	function test_all_arguments_without_url_rewriting(){
		request.cgi.script_name = "/index.cfm";
		loc.args.$URLRewriting = "Off";
		loc.webRoot = Replace("#application.wheels.webpath##ListLast(request.cgi.script_name, '/')#", "//", "/");
		loc.e = "#loc.webRoot#?controller=blog&action=edit&key=1&param1=foo&param2=bar";
		loc.r = loc.controller.urlFor(argumentcollection=loc.args);
		assert("loc.e eq loc.r");
	}

	function test_missing_controller_without_url_rewriting(){
		request.cgi.script_name = "/index.cfm";
		loc.args.$URLRewriting = "Off";
		StructDelete(loc.args, "controller");
		loc.webRoot = Replace("#application.wheels.webpath##ListLast(request.cgi.script_name, '/')#", "//", "/");
		loc.e = "#loc.webRoot#?controller=blog&action=edit&key=1&param1=foo&param2=bar";
		loc.r = loc.controller.urlFor(argumentcollection=loc.args);
		assert("loc.e eq loc.r");
	}

	function test_missing_action_without_url_rewriting(){
		request.cgi.script_name = "/index.cfm";
		loc.args.$URLRewriting = "Off";
		StructDelete(loc.args, "action");
		loc.webRoot = Replace("#application.wheels.webpath##ListLast(request.cgi.script_name, '/')#", "//", "/");
		loc.e = "#loc.webRoot#?controller=blog&action=edit&key=1&param1=foo&param2=bar";
		loc.r = loc.controller.urlFor(argumentcollection=loc.args);
		assert("loc.e eq loc.r");
	}

	function test_missing_controller_and_action_without_url_rewriting(){
		request.cgi.script_name = "/index.cfm";
		loc.args.$URLRewriting = "Off";
		StructDelete(loc.args, "controller");
		StructDelete(loc.args, "action");
		loc.webRoot = Replace("#application.wheels.webpath##ListLast(request.cgi.script_name, '/')#", "//", "/");
		loc.e = "#loc.webRoot#?controller=blog&action=edit&key=1&param1=foo&param2=bar";
		loc.r = loc.controller.urlFor(argumentcollection=loc.args);
		assert("loc.e eq loc.r");
	}
}
