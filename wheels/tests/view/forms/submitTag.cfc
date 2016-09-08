component extends="wheels.tests.Test" {

	function setup() {
		_controller = controller(name="ControllerWithModel");
	}

	function test_defaults() {
		e = _controller.submitTag();
		r = '<input type="submit" value="Save changes" />';
		debug('e', false);
		assert('e eq r');
	}

	function test_disabled_is_escaped() {
		e = _controller.submitTag(disable="Mark as: 'Completed'?");
		r = '<input onclick="this.disabled=true;this.value=''Mark as: \''Completed\''?'';this.form.submit();" type="submit" value="Save changes" />';
		assert('e eq r');
	}

	function test_append_prepend() {
		e = _controller.submitTag(append="a", prepend="p");
		r = 'p<input type="submit" value="Save changes" />a';
		assert('e eq r');
	}

}
