component{

	function init(){
		return this;
	}

	public string function returnPrivateMethod(){
		return privateMethod();
		//works if scoped to this
		//return this.privateMethod();
	}

	public string function returnPublicMethod(){
		return publicMethod();
		//works if scoped to this
		//return this.publicMethod();
	}

	private string function privateMethod(){
		return "original";
	}

	public string function publicMethod(){
		return "original";
	}

}