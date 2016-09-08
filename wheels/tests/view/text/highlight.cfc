component extends="wheels.tests.Test" {

	function setup() {
		_controller = controller(name="dummy");
		args = {};
		args.text = "CFWheels test to do see if hightlight function works or not.";
		args.phrases = "hightlight function";
		args.class = "cfwheels-hightlight";
	}

	function test_phrase_found() {
		e = _controller.highlight(argumentcollection=args);
		r = 'CFWheels test to do see if <span class="cfwheels-hightlight">hightlight function</span> works or not.';
		assert("e eq r");
	}

	function test_phrase_not_found() {
		args.phrases = "xxxxxxxxx";
		e = _controller.highlight(argumentcollection=args);
		r = 'CFWheels test to do see if hightlight function works or not.';
		assert("e eq r");
	}

	function test_phrase_found_no_class_defined() {
		structdelete(args, "class");
		args.phrases = "hightlight function";
		e = _controller.highlight(argumentcollection=args);
		r = 'CFWheels test to do see if <span class="highlight">hightlight function</span> works or not.';
		assert("e eq r");
	}

	function test_phrase_not_found_no_class_defined() {
		args.phrases = "xxxxxxxxx";
		e = _controller.highlight(argumentcollection=args);
		r = 'CFWheels test to do see if hightlight function works or not.';
		assert("e eq r");
	}

	function test_delimiter() {
		args.delimiter = "|";
		args.phrases = "test to|function|or not";
		e = _controller.highlight(argumentcollection=args);
		r = 'CFWheels <span class="cfwheels-hightlight">test to</span> do see if hightlight <span class="cfwheels-hightlight">function</span> works <span class="cfwheels-hightlight">or not</span>.';
		assert("e eq r");
	}

	function test_mark_tag() {
		args.tag = "mark";
		e = _controller.highlight(argumentcollection=args);
		r = 'CFWheels test to do see if <mark class="cfwheels-hightlight">hightlight function</mark> works or not.';
		assert("e eq r");
	}

}
