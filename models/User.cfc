component extends="Model" {

	function config() {
		afterFind("addArgumentsInUserRecordsAfterFind");
	}

	private struct function addArgumentsInUserRecordsAfterFind() {
	    arguments.foo = "bar";
	    return arguments;
	}

}
