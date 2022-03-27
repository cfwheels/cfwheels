component extends="wheels.tests.Test" {

	function test_override_created_at_with_allow_explicit_timestamps() {

		author = model("author").findOne(order = "id");
		
		transaction {

			twentyDaysAgo = dateAdd("d", -20, now());
			
			newPost = model("post").new(allowExplicitTimestamps=true);
			newPost.authorId = author.id;
			newPost.title = "New title";
			newPost.body = "New Body";
			newPost.createdAt = twentyDaysAgo;
			newPost.updatedAt = twentyDaysAgo;

			newPost.save(transaction="none");
			
			assert("newPost.createdAt == twentyDaysAgo");
			
			transaction action="rollback";
		}
	}

	function test_override_updated_at_with_allow_explicit_timestamps() {

		author = model("author").findOne(order = "id");
		
		transaction {

			twentyDaysAgo = dateAdd("d", -20, now());
			
			newPost = model("post").new(allowExplicitTimestamps=true);
			newPost.authorId = author.id;
			newPost.title = "New title";
			newPost.body = "New Body";
			newPost.createdAt = twentyDaysAgo;
			newPost.updatedAt = twentyDaysAgo;
			newPost.save(transaction="none");
			
			assert("newPost.updatedAt == twentyDaysAgo");
			
			transaction action="rollback";
		}
	}
}