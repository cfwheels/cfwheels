component extends="wheels.tests.Test" {

	function test_override_created_at_with_allow_explicit_timestamps() {
		author = model("author").findOne(order = "id");

		transaction {
			twentyDaysAgo = DateAdd("d", -20, Now());

			newPost = model("post").new(allowExplicitTimestamps = true);
			newPost.authorId = author.id;
			newPost.title = "New title";
			newPost.body = "New Body";
			newPost.createdAt = twentyDaysAgo;
			newPost.updatedAt = twentyDaysAgo;

			newPost.save(transaction = "none");

			assert("newPost.createdAt eq twentyDaysAgo");

			transaction action="rollback";
		}
	}

	function test_override_updated_at_with_allow_explicit_timestamps() {
		author = model("author").findOne(order = "id");

		transaction {
			twentyDaysAgo = DateAdd("d", -20, Now());

			newPost = model("post").new(allowExplicitTimestamps = true);
			newPost.authorId = author.id;
			newPost.title = "New title";
			newPost.body = "New Body";
			newPost.createdAt = twentyDaysAgo;
			newPost.updatedAt = twentyDaysAgo;
			newPost.save(transaction = "none");

			assert("newPost.updatedAt eq twentyDaysAgo");

			transaction action="rollback";
		}
	}

}
