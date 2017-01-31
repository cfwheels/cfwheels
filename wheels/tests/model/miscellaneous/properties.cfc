component extends="wheels.tests.Test" {

	function test_key() {
		author = model("author").findOne();
		result = author.key();
		assert("result IS author.id");
	}

	function test_key_with_new() {
		author = model("author").new(id=1, firstName="Per", lastName="Djurner");
		result = author.key();
		assert("result IS 1");
	}

	function test_setting_and_getting_properties() {

		user = model("user").new();

		args = {};
		args.Address = "1313 mockingbird lane";
		args.City = "deerfield beach";
		args.Fax = "9545551212";
		args.FirstName = "anthony";
		args.LastName = "Petruzzi";
		args.Password = "it's a secret";
		args.Phone = "9544826106";
		args.State = "fl";
		args.UserName = "tonypetruzzi";
		args.ZipCode = "33441";
		args.Id = "";
		args.birthday = "11/01/1975";
		args.birthdaymonth = "11";
		args.birthdayyear = "1975";

		user.setProperties(args);

		props = user.properties();

		for (i in props) {
			actual = props[i];
			expected = args[i];
			assert("actual eq expected");
		};

		args.FirstName = "per";
		args.LastName = "djurner";

		user.setproperties(firstname="per", lastname="djurner");
		props = user.properties();

		for (i in props) {
			actual = props[i];
			expected = args[i];
			assert("actual eq expected");
		};

		args.FirstName = "chris";
		args.LastName = "peters";
		args.ZipCode = "33333";

		_params = {};
		_params.lastname = "peters";
		_params.zipcode = "33333";

		user.setproperties(firstname="chris", properties=_params);
		props = user.properties();

		for (i in props) {
			actual = props[i];
			expected = args[i];
			assert("actual eq expected");
		};
	}

	function test_setting_and_getting_properties_with_named_arguments() {
		author = model("author").findOne();
		author.setProperties(firstName="a", lastName="b");
		result = author.properties();
		assert('result.firstName eq "a"');
		assert('result.lastName eq "b"');
	}

	function test_getting_nested_objects_with_simple_argument() {
		adam = {firstName="adam", lastName="chapman"};
		postOne = {views="1000", averageRating=1.0, body="This is the single body", title="this is the single title"};
		postTwo = {views="2000", averageRating=2.0, body="This is the arrays first body", title="this is the arrays first title"};
		postThree = {views="3000", averageRating=3.0, body="This is the arrays second body", title="this is the arrays second title"};

		author = model("author").new(adam);
		author.post = model("post").new(postOne);
		author.posts = [model("post").new(postTwo), model("post").new(postThree)];

		simpleAuthor = author.properties(simple=true);
		complexAuthor = author.properties();

		actual = simpleAuthor;
		expected = adam;
		expected.post = postOne;
		expected.posts = [postTwo, postThree];

		assert("IsObject(complexAuthor.post)");
		assert("ListSort(StructKeyList(actual), 'textNoCase') eq ListSort(StructKeyList(expected), 'textNoCase')");
		assert("ListSort(StructKeyList(actual.post), 'textNoCase') eq ListSort(StructKeyList(expected.post), 'textNoCase')");
		assert("ListSort(StructKeyList(actual.posts[1]), 'textNoCase') eq ListSort(StructKeyList(expected.posts[1]), 'textNoCase')");
		assert("ListSort(StructKeyList(actual.posts[2]), 'textNoCase') eq ListSort(StructKeyList(expected.posts[2]), 'textNoCase')");
		/* this would be a lot simpler, but the JSON is serialised differently on ACF10 */
		/* assert("SerializeJSON(actual) eq SerializeJSON(expected)"); */
	}

}
