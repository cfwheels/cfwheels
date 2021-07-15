component extends="wheels.tests.Test" {

	function setup() {
		user = model("user").findOne();
	}

	function test_get_associated_errors_returns_array_including_associated_model_errors() {
		user.addError("firstname", "firstname error1");
		user.author = model("author").findOne(include = "profile");
		user.author.addError("lastname", "lastname error1");
		associatedErrors = user.allAssociationErrors();
		actual = ArrayLen(associatedErrors);
		errors = user.allErrors();
		actual += ArrayLen(errors);
		ArrayAppend(errors, user.author.allErrors(), true);
		expected = ArrayLen(errors);
		assert("actual eq expected");
	}

	function test_get_associated_errors_returns_array_including_associated_model_errors_deeply() {
		user.addError("firstname", "firstname error1");
		user.author = model("author").findOne(include = "profile");
		user.author.addError("lastname", "lastname error1");
		user.author.profile.addError("profiletype", "profiletype error1");
		associatedErrors = user.allAssociationErrors();
		actual = ArrayLen(associatedErrors);
		errors = user.allErrors();
		actual += ArrayLen(errors);
		ArrayAppend(errors, user.author.profile.allErrors(), true);
		ArrayAppend(errors, user.author.allErrors(), true);
		expected = ArrayLen(errors);
		assert("actual eq expected");
	}

	function test_get_associated_errors_returns_array_including_associated_model_errors_and_handles_circular_reference() {
		user.addError("firstname", "firstname error1");
		user.author = model("author").findOne(include = "profile");
		user.author.addError("lastname", "lastname error1");
		user.author.profile.addError("profiletype", "profiletype error1");
		user.author.profile.$classData().associations.author.nested.allow = false;
		user.author.profile.author = user.author;
		associatedErrors = user.allAssociationErrors();
		actual = ArrayLen(associatedErrors);
		errors = user.allErrors();
		actual += ArrayLen(errors);
		ArrayAppend(errors, user.author.profile.allErrors(), true);
		ArrayAppend(errors, user.author.allErrors(), true);
		expected = ArrayLen(errors);
		assert("actual eq expected");
	}

}
