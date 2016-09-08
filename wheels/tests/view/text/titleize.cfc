component extends="wheels.tests.Test" {

	function setup() {
		_controller = controller(name="dummy");
		args = {};
		args.word = "this is a test to see if this works or not.";
	}

	function test_sentence_should_titleize() {
		e = _controller.titleize(argumentcollection=args);
		r = "This Is A Test To See If This Works Or Not.";
		assert("e eq r");
	}

}
