component extends="wheels.tests.Test" {

	function setup() {
	  _debug = false;
	}

	function test_properties_returns_expected_struct_keys() {
		author = model("author").new(firstName="Foo", lastName="Bar");

		_properties = author.properties();
		actual = ListSort(StructKeyList(_properties), "text");
		expected = "firstName,lastName";

		assert('actual eq expected');
		assert("author.firstName eq 'Foo'");
		assert("author.lastName eq 'Bar'");
	}

	function test_nested_property_returns_as_struct_by_default() {
		author = model("author").new(firstName="Foo", lastName="Bar");
		author.post = model("post").new(title="Brown Fox");

		_properties = author.properties();
		actual = IsObject(_properties.post);
		expected = false;

		debug("author.properties()", _debug);

		assert('actual eq expected');
	}

	function test_nested_property_returns_object_when_returnincludedas_is_object() {
		author = model("author").new(firstName="Foo", lastName="Bar");
		author.post = model("post").new(title="Brown Fox");

		_properties = author.properties(returnIncludedAs="object");
		actual = IsObject(_properties.post);
		expected = true;

		debug("author.properties()", _debug);

		assert('actual eq expected');
	}

	function test_nested_properties_returns_array_of_structs_by_default() {
		author = model("author").new(firstName="Foo", lastName="Bar");
		author.posts = [
			model("post").new(title="Brown Fox"),
			model("post").new(title="Lazy Dog")
		];

		actual = author.properties().posts[2];

		debug("actual", _debug);

		assert('! IsObject(actual)');
		assert('IsStruct(actual)');
	}

	function test_nested_property_is_not_returned_when_returnincluded_is_false() {
		author = model("author").new(firstName="Foo", lastName="Bar");
		author.post = model("post").new(title="Brown Fox");

		_properties = author.properties(returnIncluded=false);
		actual = ListSort(StructKeyList(_properties), "text");
		expected = "firstName,lastName";

		debug("author.properties()", _debug);

		assert('actual eq expected');
	}

}
