component extends="Model" {

	function init() {
		table("users");
		property(name="birthDay", column="birthday");
		automaticValidations(true);
	}

}