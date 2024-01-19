component extends="testbox.system.compat.framework.TestCase" {

/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeTests(){
		application.salvador = 1;
	}

	function afterTests(){
		structClear( application );
	}

	function setup(){
		request.foo = 1;
	}

	function teardown(){
		structClear( request );
	}

/*********************************** Test Methods ***********************************/

	/**
	* @mxunit:expectedException
	*/
	function testExpectedExceptionNoValue(){
		// This method should throw an invalid exception and pass
		throw( type="InvalidException", message="This test method should pass with an expected exception" );
	}

	function testShouldThrowException(){
		var c = new tests.resources.Collaborator();
		c.getDataFromDB();
	}

	/**
	* @mxunit:expectedException InvalidException
	*/
	function testExpectedExceptionWithValue(){
		// This method should throw an invalid exception and pass
		throw( type="InvalidException", message="This test method should pass with an expected exception of type InvalidException" );
	}

	function testExpectedExceptionFromMethodWithType(){
		expectedException( "InvalidException" );
		// This method should throw an invalid exception and pass
		throw( type="InvalidException", message="This test method should pass with an expected exception" );
	}

	function testExpectedExceptionFromMethodWithTypeAndRegex(){
		expectedException( "InvalidException", "(pass with an)" );
		// This method should throw an invalid exception and pass
		throw( type="InvalidException", message="This test method should pass with an expected exception" );
	}

	function testExpectException_should_fail(){
		expectException("MyException");
	}

	function testRaiseException_pass(){
		expectException("MyException");
		raiseExpectedException();
	}
	function testRaiseException_fail_wrong_exception_raised(){
		expectException("MyException");
		try{
			raiseUnexpectedException();
		}
		catch( "DifferentException" e ){}
		catch( Any e ){ rethrow; }
	}

	private	function raiseExpectedException(){
		throw(type="MyException");
	}

	private function raiseUnexpectedException(){
		throw(type="DifferentException");
	}

	private function getData(){
		return [1,2,3];
	}

}