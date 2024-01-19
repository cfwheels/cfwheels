component extends="testbox.system.compat.framework.TestCase" {

	private string function injectedPrivateMethod(){
		return "injected";
	}

	public string function injectedPublicMethod(){
		return "injected";
	}

	public function testInjectedPrivateMethod(){
		var sut = New tests.resources.Sut();
		// replace privateMethod in the SUT with an injected mock method
		injectMethod(
			sut,
			this,
			"injectedPrivateMethod",
			"privateMethod"
		);
		// The SUT should use the injected method instead of its original version
		assert( sut.returnPrivateMethod() IS "injected" );
	}

	public function testInjectedPublicMethod(){
		var sut = New tests.resources.Sut();
		// replace publicMethod in the SUT with an injected mock method
		injectMethod(
			sut,
			this,
			"injectedPublicMethod",
			"publicMethod"
		);
		// The SUT should use the injected method instead of its original version
		assert( sut.returnPublicMethod() IS "injected" );
	}

}
