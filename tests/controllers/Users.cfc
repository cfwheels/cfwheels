component extends="wheels.Test" {

	function setup(){

	}

	function teardown(){

	}

	// Your controller tests here:
	function testKeyFunctionReturnsNumericValueWhenPrimaryKeyIsNumeric(){
		userResponse = [];

		user = model("user").findByKey(1);

		arrayAppend(userResponse, {
			"id": user.key(),
			"firstname": user.firstname,
			"lastname": user.lastname,
			"email": user.email
		});

		userResponseJSON = serializeJSON(userResponse);

		assert("find('""id"":1',userResponseJSON)");
	}
}
