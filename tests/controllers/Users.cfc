component extends="wheels.Test" {

	function setup(){

	}

	function teardown(){

	}

	// Your controller tests here:
	function testFindallFiresAfterfindCallbackHook(){
		users=model("user").findAll(returnAs = 'struct');

		assert('StructKeyExists(users[1], "foo")');
	}
}
