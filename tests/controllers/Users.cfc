component extends="wheels.Test" {

	function setup(){

	}

	function teardown(){

	}

	function testInvalidSelectColumnThrowsException(){
		users = model("user").findAll(select='id,email,firstname,lastname,createdat,foo');
	}
}
