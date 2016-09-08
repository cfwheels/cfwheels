component extends="Model" {

	function init() {
		afterFind("afterFindCallback");
	}

	function afterFindCallback() {
		arguments.method = "done";
		return arguments;
	}

}
