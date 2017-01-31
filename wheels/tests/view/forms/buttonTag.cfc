component extends="wheels.tests.Test" {

	function setup() {
		_controller = controller(name="dummy");
		imagePath = application.wheels.webPath & application.wheels.imagePath;
	}

	function test_defaults() {
		r = _controller.buttonTag();
		e = '<button type="submit" value="save">Save changes</button>';
		assert('e eq r');
	}

	function test_with_image() {
		r = _controller.buttonTag(image="http://www.cfwheels.com/logo.jpg");
		e = '<button type="submit" value="save"><img alt="Logo" src="http://www.cfwheels.com/logo.jpg" type="image" /></button>';
		assert('e eq r');
	}

	function test_with_disable() {
		r = _controller.buttonTag(disable="Are you sure?");
		e = '<button onclick="this.disabled=true;this.value=''Are you sure?'';this.form.submit();" type="submit" value="save">Save changes</button>';
		assert('e eq r');
	}

	function test_append_prepend() {
		r = _controller.buttonTag(append="a", prepend="p");
		e = 'p<button type="submit" value="save">Save changes</button>a';
		assert('e eq r');
	}

}
