component extends="wheels.tests.Test" {

	function setup() {
	}

	function test_get_associated_errors_returns_array_including_associated_model_errors() {
		user = model("user").findOne();
		user.addError("firstname", "firstname error1");
		user.author = model("author").findOne(include = "profile");
		user.author.addError("lastname", "lastname error1");
		errors = user.allErrors(includeAssociations = true);
		actual = ArrayLen(errors);
		expected = 2;
		assert("actual eq expected");
	}

	function test_get_associated_errors_returns_array_including_associated_model_errors_deeply() {
		user = model("user").findOne();
		user.addError("firstname", "firstname error1");
		user.author = model("author").findOne(include = "profile");
		user.author.addError("lastname", "lastname error1");
		user.author.profile.addError("profiletype", "profiletype error1");
		errors = user.allErrors(includeAssociations = true);
		actual = ArrayLen(errors);
		expected = 3;
		assert("actual eq expected");
	}

	function test_get_associated_errors_returns_array_including_associated_model_errors_and_handles_circular_reference() {
		user = model("user").findOne();
		user.addError("firstname", "firstname error1");
		user.author = model("author").findOne(include = "profile");
		user.author.addError("lastname", "lastname error1");
		user.author.profile.addError("profiletype", "profiletype error1");
		user.author.profile.$classData().associations.author.nested.allow = true;
		user.author.profile.$classData().associations.author.nested.autoSave = true;
		user.author.profile.author = user.author;
		errors = user.allErrors(includeAssociations = true);
		actual = ArrayLen(errors);
		expected = 3;
		user.author.profile.$classData().associations.author.nested.allow = false;
		user.author.profile.$classData().associations.author.nested.autoSave = false;
		assert("actual eq expected");
	}

}
