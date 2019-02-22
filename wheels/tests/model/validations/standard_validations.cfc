component extends="wheels.tests.Test" {

	function setup() {
		StructDelete(application.wheels.models, "users", false);
		StructDelete(application.wheels.models, "tag", false);
		user = model("users").new();
	}

	/* validatesConfirmationOf */
	function test_validatesConfirmationOf_valid() {
		user.password = "hamsterjelly";
		user.passwordConfirmation = "hamsterjelly";
		user.validatesConfirmationOf(property="password");
		assert('user.valid()');
	}

	function test_validatesConfirmationOf_invalid() {
		user.password = "hamsterjelly";
		user.passwordConfirmation = "hamsterjellysucks";
		user.validatesConfirmationOf(property="password");
		assert('!user.valid()');
	}

	function test_validatesConfirmationOf_missing_property_valid() {
		user.passwordConfirmation = "hamsterjellysucks";
		user.validatesConfirmationOf(property="password");
		assert('user.valid()');
	}

	function test_validatesConfirmationOf_missing_property_confirmation_valid() {
		user.password = "hamsterjelly";
		user.validatesConfirmationOf(property="password");
		assert('user.valid()');
	}

	function test_validatesConfirmationOf_valid_case() {
		user.password = "HamsterJelly";
		user.passwordConfirmation = "HamsterJelly";
		user.validatesConfirmationOf(property="password", caseSensitive=true);
		assert('user.valid()');
	}

	function test_validatesConfirmationOf_invalid_case() {
		user = model("users").new();
		user.password = "HamsterJelly";
		user.passwordConfirmation = "hamsterjelly";
		user.validatesConfirmationOf(property="password", caseSensitive=true);
		assert('!user.valid()');
	}

	/* validatesExclusionOf */
	function test_validatesExclusionOf_valid() {
		user.firstname = "tony";
		user.validatesExclusionOf(property="firstname", list="per, raul, chris");
		assert('user.valid()');
	}

	function test_validatesExclusionOf_invalid() {
		user.firstname = "tony";
		user.validatesExclusionOf(property="firstname", list="per, raul, chris, tony");
		assert('!user.valid()');
	}

	function test_validatesExclusionOf_missing_property_invalid() {
		user.validatesExclusionOf(property="firstname", list="per, raul, chris, tony");
		assert('!user.valid()');
	}

	function test_validatesExclusionOf_missing_property_valid() {
		user.validatesExclusionOf(property="firstname", list="per, raul, chris, tony", allowblank="true");
		assert('user.valid()');
	}

	function test_validatesExclusionOf_allowblank_valid() {
		user.firstname = "";
		user.validatesExclusionOf(property="firstname", list="per, raul, chris", allowblank="true");
		assert('user.valid()');
	}

	function test_validatesExclusionOf_allowblank_invalid() {
		user.firstname = "";
		user.validatesExclusionOf(property="firstname", list="per, raul, chris", allowblank="false");
		assert('!user.valid()');
	}


	/* validatesFormatOf */
	function test_validatesFormatOf_valid() {
		user.phone = "954-555-1212";
		user.validatesFormatOf(property="phone", regex="(\d{3,3}-){2,2}\d{4,4}");
		assert('user.valid()');
	}

	function test_validatesFormatOf_invalid() {
		user.phone = "(954) 555-1212";
		user.validatesFormatOf(property="phone", regex="(\d{3,3}-){2,2}\d{4,4}");
		assert('!user.valid()');
	}

	function test_validatesFormatOf_missing_property_invalid() {
		user.validatesFormatOf(property="phone", regex="(\d{3,3}-){2,2}\d{4,4}");
		assert('!user.valid()');
	}

	function test_validatesFormatOf_missing_property_valid() {
		user.validatesFormatOf(property="phone", regex="(\d{3,3}-){2,2}\d{4,4}", allowBlank="true");
		assert('user.valid()');
	}

	function test_validatesFormatOf_allowblank_valid() {
		user.phone = "";
		user.validatesFormatOf(property="phone", regex="(\d{3,3}-){2,2}\d{4,4}", allowBlank="true");
		assert('user.valid()');
	}

	function test_validatesFormatOf_allowblank_invalid() {
		user.phone = "";
		user.validatesFormatOf(property="phone", regex="(\d{3,3}-){2,2}\d{4,4}", allowBlank="false");
		assert('!user.valid()');
	}


	/* validatesInclusionOf */
	function test_validatesInclusionOf_invalid() {
		user.firstname = "tony";
		user.validatesExclusionOf(property="firstname", list="per, raul, chris");
		assert('user.valid()');
	}

	function test_validatesInclusionOf_valid() {
		user.firstname = "tony";
		user.validatesExclusionOf(property="firstname", list="per, raul, chris, tony");
		assert('!user.valid()');
	}

	function test_validatesInclusionOf_missing_property_invalid() {
		user.validatesExclusionOf(property="firstname", list="per, raul, chris, tony");
		assert('!user.valid()');
	}

	function test_validatesInclusionOf_missing_property_valid() {
		user.validatesExclusionOf(property="firstname", list="per, raul, chris, tony", allowblank="true");
		assert('user.valid()');
	}

	function test_validatesInclusionOf_allowblank_valid() {
		user.firstname = "";
		user.validatesExclusionOf(property="firstname", list="per, raul, chris", allowblank="true");
		assert('user.valid()');
	}

	function test_validatesInclusionOf_allowblank_invalid() {
		user.firstname = "";
		user.validatesExclusionOf(property="firstname", list="per, raul, chris", allowblank="false");
		assert('!user.valid()');
	}


	/* validatesLengthOf */
	function test_validatesLengthOf_maximum_minimum_invalid() {
		user.firstname = "thi";
		user.validatesLengthOf(property="firstname", minimum="5", maximum="20");
		assert('!user.valid()');
	}

	function test_validatesLengthOf_maximum_valid() {
		user.firstname = "thisisatestagain";
		user.validatesLengthOf(property="firstname", maximum="20");
		assert('user.valid()');
	}

	function test_validatesLengthOf_maximum_invalid() {
		user.firstname = "thisisatestagain";
		user.validatesLengthOf(property="firstname", maximum="15");
		assert('!user.valid()');
	}

	function test_validatesLengthOf_missing_property_invalid() {
		user.validatesLengthOf(property="firstname", maximum="15");
		assert('!user.valid()');
	}

	function test_validatesLengthOf_missing_property_valid() {
		user.validatesLengthOf(property="firstname", maximum="15", allowblank="true");
		assert('user.valid()');
	}

	function test_validatesLengthOf_minimum_valid() {
		user.firstname = "thisisatestagain";
		user.validatesLengthOf(property="firstname", minimum="15");
		assert('user.valid()');
	}

	function test_validatesLengthOf_minimum_invalid() {
		user.firstname = "thisisatestagain";
		user.validatesLengthOf(property="firstname", minimum="20");
		assert('!user.valid()');
	}

	function test_validatesLengthOf_within_valid() {
		user.firstname = "thisisatestagain";
		user.validatesLengthOf(property="firstname", within="15,20");
		assert('user.valid()');
	}

	function test_validatesLengthOf_within_invalid() {
		user.firstname = "thisisatestagain";
		user.validatesLengthOf(property="firstname", within="10,15");
		assert('!user.valid()');
	}

	function test_validatesLengthOf_exactly_valid() {
		user.firstname = "thisisatestagain";
		user.validatesLengthOf(property="firstname", exactly="16");
		assert('user.valid()');
	}

	function test_validatesLengthOf_exactly_invalid() {
		user.firstname = "thisisatestagain";
		user.validatesLengthOf(property="firstname", exactly="20");
		assert('!user.valid()');
	}

	function test_validatesLengthOf_allowblank_valid() {
		user.firstname = "";
		user.validatesLengthOf(property="firstname", allowblank="true");
		assert('user.valid()');
	}

	function test_validatesLengthOf_allowblank_invalid() {
		user.firstname = "";
		user.validatesLengthOf(property="firstname", allowblank="false");
		assert('!user.valid()');
	}


	/* validatesNumericalityOf */
	function test_validatesNumericalityOf_valid() {
		user.birthdaymonth = "10";
		user.validatesNumericalityOf(property="birthdaymonth");
		assert('user.valid()');
	}

	function test_validatesNumericalityOf_invalid() {
		user.birthdaymonth = "1,000.00";
		user.validatesNumericalityOf(property="birthdaymonth");
		assert('!user.valid()');
	}

	function test_validatesNumericalityOf_missing_property_invalid() {
		user.validatesNumericalityOf(property="birthdaymonth", onlyInteger="true");
		assert('!user.valid()');
	}

	function test_validatesNumericalityOf_missing_property_valid() {
		user.validatesNumericalityOf(property="birthdaymonth", onlyInteger="true", allowblank="true");
		assert('user.valid()');
	}

	function test_validatesNumericalityOf_onlyInteger_valid() {
		user.birthdaymonth = "1000";
		user.validatesNumericalityOf(property="birthdaymonth", onlyInteger="true");
		assert('user.valid()');
	}

	function test_validatesNumericalityOf_onlyInteger_invalid() {
		user.birthdaymonth = "1000.25";
		user.validatesNumericalityOf(property="birthdaymonth", onlyInteger="true");
		assert('!user.valid()');
	}

	function test_validatesNumericalityOf_allowBlank_valid() {
		user.birthdaymonth = "";
		user.validatesNumericalityOf(property="birthdaymonth", allowBlank="true");
		assert('user.valid()');
	}

	function test_validatesNumericalityOf_allowBlank_invalid() {
		user.birthdaymonth = "";
		user.validatesNumericalityOf(property="birthdaymonth", allowBlank="false");
		assert('!user.valid()');
	}

	function test_validatesNumericalityOf_greaterThan_valid() {
		user.birthdaymonth = "11";
		user.validatesNumericalityOf(property="birthdaymonth", greatThan="10");
		assert('user.valid()');
	}

	function test_validatesNumericalityOf_greaterThan_invalid() {
		user.birthdaymonth = "10";
		user.validatesNumericalityOf(property="birthdaymonth", greaterThan="10");
		assert('!user.valid()');
	}

	function test_validatesNumericalityOf_greaterThanOrEqualTo_valid() {
		user.birthdaymonth = "10";
		user.validatesNumericalityOf(property="birthdaymonth", greaterThanOrEqualTo="10");
		assert('user.valid()');
	}

	function test_validatesNumericalityOf_greaterThanOrEqualTo_invalid() {
		user.birthdaymonth = "9";
		user.validatesNumericalityOf(property="birthdaymonth", greaterThanOrEqualTo="10");
		assert('!user.valid()');
	}

	function test_validatesNumericalityOf_greaterThanOrEqualTo_invalid_float() {
		user.birthdaymonth = "11.25";
		user.validatesNumericalityOf(property="birthdaymonth", greaterThanOrEqualTo="11.30");
		assert('!user.valid()');
	}

	function test_validatesNumericalityOf_equalTo_valid() {
		user.birthdaymonth = "10";
		user.validatesNumericalityOf(property="birthdaymonth", equalTo="10");
		assert('user.valid()');
	}

	function test_validatesNumericalityOf_equalTo_invalid() {
		user.birthdaymonth = "9";
		user.validatesNumericalityOf(property="birthdaymonth", equalTo="10");
		assert('!user.valid()');
	}

	function test_validatesNumericalityOf_lessThan_valid() {
		user.birthdaymonth = "9";
		user.validatesNumericalityOf(property="birthdaymonth", lessThan="10");
		assert('user.valid()');
	}

	function test_validatesNumericalityOf_lessThan_invalid() {
		user.birthdaymonth = "10";
		user.validatesNumericalityOf(property="birthdaymonth", lessThan="10");
		assert('!user.valid()');
	}

	function test_validatesNumericalityOf_lessThanOrEqualTo_valid() {
		user.birthdaymonth = "10";
		user.validatesNumericalityOf(property="birthdaymonth", lessThanOrEqualTo="10");
		assert('user.valid()');
	}

	function test_validatesNumericalityOf_lessThanOrEqualTo_invalid() {
		user.birthdaymonth = "11";
		user.validatesNumericalityOf(property="birthdaymonth", lessThanOrEqualTo="10");
		assert('!user.valid()');
	}

	function test_validatesNumericalityOf_odd_valid() {
		user.birthdaymonth = "13";
		user.validatesNumericalityOf(property="birthdaymonth", odd="true");
		assert('user.valid()');
	}

	function test_validatesNumericalityOf_odd_invalid() {
		user.birthdaymonth = "14";
		user.validatesNumericalityOf(property="birthdaymonth", odd="true");
		assert('!user.valid()');
	}

	function test_validatesNumericalityOf_even_valid() {
		user.birthdaymonth = "14";
		user.validatesNumericalityOf(property="birthdaymonth", even="true");
		assert('user.valid()');
	}

	function test_validatesNumericalityOf_even_invalid() {
		user.birthdaymonth = "13";
		user.validatesNumericalityOf(property="birthdaymonth", even="true");
		assert('!user.valid()');
	}


	/* validatesPresenceOf */
	function test_validatesPresenceOf_valid() {
		user.firstname = "tony";
		user.validatesPresenceOf(property="firstname");
		assert('user.valid()');
	}

	function test_validatesPresenceOf_invalid() {
		user.validatesPresenceOf(property="firstname");
		assert('!user.valid()');
	}

	function test_validatesPresenceOf_invalid_when_blank() {
		user.firstname = "   ";
		user.validatesPresenceOf(property="firstname");
		assert('!user.valid()');
	}


	/* validatesUniquenessOf */
	function test_validatesUniquenessOf_valid() {
		user.firstname = "Tony";
		user.validatesUniquenessOf(property="firstname");
		if (!IsBoolean(user.tableName()) OR user.tableName()) {
			assert('!user.valid()');
		} else {
			assert('user.valid()');
		}
	}

	function test_validatesUniquenessOf_valids_when_updating_existing_record() {
		user = model("user").findOne(where="firstName = 'Tony'");
		user.validatesUniquenessOf(property="firstName");
		assert('user.valid()');
		// Special case for testing when we already have duplicates in the database:
		// https://github.com/cfwheels/cfwheels/issues/480
		transaction action="begin" {
			user.create(firstName="Tony", username="xxxx", password="xxxx", lastname="xxxx", validate=false);
			firstUser = model("user").findOne(where="firstName = 'Tony'", order="id ASC");
			lastUser = model("user").findOne(where="firstName = 'Tony'", order="id DESC");
			assert('!firstUser.valid() && !lastUser.valid()');
			transaction action="rollback";
		}
	}

	function test_validatesUniquenessOf_takes_softdeletes_into_account() {
			transaction action="begin" {
			org_post = model('post').findOne();
			properties = org_post.properties();
			new_post = model('post').new(properties);
			org_post.delete();
			valid = new_post.valid();
			assert('valid eq false');
			transaction action="rollback";
		}
	}

	function test_validatesUniquenessOf_with_blank_integer_values() {
		combiKey = model("combiKey").new(id1="", id2="");
		assert("not combiKey.valid()");
	}

	function test_validatesUniquenessOf_with_blank_property_value() {
		tag = model("tag").new(
			name = "angel",
			description = "of death",
			parentid = ""
		);
		tag.validatesUniquenessOf(property="parentid");
		assert('!tag.valid()');
	}
	/*
	function test_validatesUniquenessOf_with_blank_property_value_with_allowBlank() {
		tag = model("tag").new(
			name = "angel",
			description = "of death",
			parentid = ""
		);
		tag.validatesUniquenessOf(property="parentid", allowBlank="true");
		assert('tag.valid()');
	}*/

	/* validate */
	function test_validate_registering_methods() {
		user.firstname = "tony";
		user.validate(method="fakemethod");
		user.validate(method="fakemethod2", when="onCreate");
		v = user.$classData().validations;
		onsave = v["onsave"];
		oncreate = v["oncreate"];
		assert('arraylen(onsave) eq 1');
		assert('onsave[1].method eq "fakemethod"');
		assert('arraylen(oncreate) eq 1');
		assert('oncreate[1].method eq "fakemethod2"');
	}

}
