component extends="wheels.tests.Test" {

	function test_properties_returns_struct_keys() {
		author = model("author").new(firstName="Foo", lastName="Bar");

		actual = ListSort(StructKeyList(author.properties()), "text");
		expected = "firstName,lastName";

		assert('actual eq expected');
		assert("author.firstName eq 'Foo'");
		assert("author.lastName eq 'Bar'");
	}

	function test_nested_property_returns_as_struct() {
		author = model("author").new(firstName="Foo", lastName="Bar");
		author.post = model("post").new(title="Brown Fox");

		actual = IsObject(author.properties().post);
		expected = false;

		debug("author.properties()", false);

		assert('actual eq expected');
	}

	function test_nested_property_returns_as_object() {
		author = model("author").new(firstName="Foo", lastName="Bar");
		author.post = model("post").new(title="Brown Fox");

		actual = IsObject(author.properties(returnAs="object").post);
		expected = true;

		debug("author.properties()", false);

		assert('actual eq expected');
	}

	function test_nested_properties_returns_array_of_structs() {
		author = model("author").new(firstName="Foo", lastName="Bar");
		author.posts = [
			model("post").new(title="Brown Fox"),
			model("post").new(title="Lazy Dog")
		];

		actual = author.properties().posts[2];

		debug("actual", false);

		assert('! IsObject(actual)');
		assert('IsStruct(actual)');
	}

}
