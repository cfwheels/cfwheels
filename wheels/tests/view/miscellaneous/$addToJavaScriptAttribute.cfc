component extends="wheels.tests.Test" {

	function setup() {
		_controller = controller(name="dummy");
		args = {};
		args.name = "WheelsTesting";
		args.content = "this is a test for the wheel's function $addToJavaScriptAttribute";
		args.attributes = {};
		args.attributes.WheelsTesting = "testing";
		args.attributes.name = "javascripttag";
	}

	function test_has_attribute_called_name() {
		e = _controller.$addToJavaScriptAttribute(argumentcollection=args);
		r = "testing;#args.content#";
		assert("e eq r");
	}

	function test_does_not_have_attribute_called_name() {
		structdelete(args.attributes, "WheelsTesting");
		e = _controller.$addToJavaScriptAttribute(argumentcollection=args);
		r = args.content;
		assert("e eq r");
	}

}
