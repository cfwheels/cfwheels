component extends="wheels.tests.Test" {

	function setup() {
		tagModel = model("tag");
		postModel = model("post");
	}

	function test_self_join() {
		tag = tagModel.findOne(where="name = 'pear'", include="parent", order="id, id");
		assert("IsObject(tag) and IsObject(tag.parent)");
	}

	function test_self_join_with_other_associations() {
		post = postModel.findByKey(key=1, include="classifications(tag(parent))", returnAs="query");
		assert("IsQuery(post) and post.recordcount");
	}

	function test_do_not_use_query_param_for_nulls() {
		result = model("author").findOne(where="lastName IS NULL");
		assert("NOT IsObject(result)");
		result = model("author").findOne(where="lastName IS NOT NULL");
		assert("IsObject(result)");
	}

	function test_parsing_numbers_in_where() {
		result = model("author").findOne(where="firstName = 1");
		assert("NOT IsObject(result)");
		result = model("author").findOne(where="firstName = 1.0");
		assert("NOT IsObject(result)");
		result = model("author").findOne(where="firstName = +1");
		assert("NOT IsObject(result)");
		result = model("author").findOne(where="firstName = -1");
		assert("NOT IsObject(result)");
	}

}
