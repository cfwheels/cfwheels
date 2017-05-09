component extends="wheels.tests.Test" {

	function setup() {
		_controller = controller(name="dummy");
		args = {};
	}

	function test_should_handle_extensions_nonextensions_and_multiple_extensions() {
		args.source = "test,test.css,jquery.dataTables.min,jquery.dataTables.min.css";
		e = _controller.styleSheetLinkTag(argumentcollection=args);
		r = '<link href="#application.wheels.webpath#stylesheets/test.css" media="all" rel="stylesheet" type="text/css">#chr(10)#<link href="#application.wheels.webpath#stylesheets/test.css" media="all" rel="stylesheet" type="text/css">#chr(10)#<link href="#application.wheels.webpath#stylesheets/jquery.dataTables.min.css" media="all" rel="stylesheet" type="text/css">#chr(10)#<link href="#application.wheels.webpath#stylesheets/jquery.dataTables.min.css" media="all" rel="stylesheet" type="text/css">#chr(10)#';
		debug(expression='htmleditformat(e)', display=false, format="text");
		debug(expression='htmleditformat(r)', display=false, format="text");
		assert("e eq r");
	}

	function test_no_automatic_extention_when_cfm() {
		args.source = "test.cfm,test.css.cfm";
		e = _controller.styleSheetLinkTag(argumentcollection=args);
		r = '<link href="#application.wheels.webpath#stylesheets/test.cfm" media="all" rel="stylesheet" type="text/css">#chr(10)#<link href="#application.wheels.webpath#stylesheets/test.css.cfm" media="all" rel="stylesheet" type="text/css">#chr(10)#';
		debug(expression='htmleditformat(e)', display=false, format="text");
		debug(expression='htmleditformat(r)', display=false, format="text");
		assert("e eq r");
	}

	function test_support_external_links() {
		args.source = "http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/themes/start/jquery-ui.css,test.css,https://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/themes/start/jquery-ui.css";
		e = _controller.styleSheetLinkTag(argumentcollection=args);
		r = '<link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/themes/start/jquery-ui.css" media="all" rel="stylesheet" type="text/css">#chr(10)#<link href="#application.wheels.webpath#stylesheets/test.css" media="all" rel="stylesheet" type="text/css">#chr(10)#<link href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/themes/start/jquery-ui.css" media="all" rel="stylesheet" type="text/css">#chr(10)#';
		debug(expression='htmleditformat(e)', display=false, format="text");
		debug(expression='htmleditformat(r)', display=false, format="text");
		assert("e eq r");
	}

	function test_allow_specification_of_delimiter() {
		args.source = "test|test.css|http://fonts.googleapis.com/css?family=Istok+Web:400,700";
		args.delim = "|";
		e = _controller.styleSheetLinkTag(argumentcollection=args);
		r = '<link href="#application.wheels.webpath#stylesheets/test.css" media="all" rel="stylesheet" type="text/css">#chr(10)#<link href="#application.wheels.webpath#stylesheets/test.css" media="all" rel="stylesheet" type="text/css">#chr(10)#<link href="http://fonts.googleapis.com/css?family=Istok+Web:400,700" media="all" rel="stylesheet" type="text/css">#chr(10)#';
		debug(expression='htmleditformat(e)', display=false, format="text");
		debug(expression='htmleditformat(r)', display=false, format="text");
		assert("e eq r");
	}

	function test_type_media_arguments() {
		args.source = "test.css";
		args.media = "";
		args.type = "";
		e = _controller.styleSheetLinkTag(argumentcollection=args);
		r = '<link href="#application.wheels.webpath#stylesheets/test.css" rel="stylesheet">#chr(10)#';
		assert("e eq r");
	}

}
