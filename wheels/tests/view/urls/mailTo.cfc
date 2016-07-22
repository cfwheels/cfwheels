component extends="wheels.tests.Test" {

	function setup(){
		loc.controller = controller(name="dummy");
	}

	function test_x_mailTo_valid(){
		loc.controller.mailTo(emailAddress="webmaster@yourdomain.com", name="Contact our Webmaster");
	}
}
