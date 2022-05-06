component extends="wheels.tests.Test" {

	function setup() {
		user = model("user").new({username = "Mike", password = "password", firstname = "Michael", lastname = "Jackson"});
		user.$classData().associations.author.nested.allow = true;
		user.$classData().associations.author.nested.autoSave = true;
	}



	function test_model_valid_returns_whether_associations_are_not_valid() {
		user.author = model("author").new();

		user.author.firstname = "";
		userValid = user.valid(validateAssociations = true);
		assert('!userValid');
	}

	function test_model_valid_returns_whether_nested_associations_are_not_valid() {
		user.author = model("author").new();

		user.author.profile = model("profile").new();
		user.author.$classData().associations.profile.nested.allow = true;
		user.author.$classData().associations.profile.nested.autoSave = true;

		user.author.profile.dateOfBirth = "";

		userValid = user.valid(validateAssociations = true);
		assert('!userValid');
	}

	function test_model_valid_returns_whether_associations_are_not_valid_with_errors_on_parent_and_associations() {
		user.author = model("author").new();
		user.author.firstname = "";

		user.author.profile = model("profile").new();
		user.author.$classData().associations.profile.nested.allow = true;
		user.author.$classData().associations.profile.nested.autoSave = true;

		user.author.profile.dateOfBirth = "";

		userValid = user.valid(validateAssociations = true);
		assert('!userValid');
	}

	function test_model_valid_returns_whether_associations_are_valid() {
		userValid = user.valid(validateAssociations = true);
		assert('userValid');
	}

}
