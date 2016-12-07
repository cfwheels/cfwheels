component extends="wheels.tests.Test" {

	function test_utc_timestamps() {
		transaction {
			utctime = DateConvert("local2Utc", Now());
			author = model("Author").findOne();
			post = author.createPost(title="test post", body="here is some text");
			assert('DateDiff("s", utctime, post.createdAt) lte 1');  // allow 1 second between test value and inserted value
			assert('DateDiff("s", utctime, post.updatedAt) lte 1');
			transaction action="rollback";
		}
	}

	function test_local_timestamps() {
		transaction {
			localtime = Now();
			model("Post").getClass().timeStampMode = "local";
			author = model("Author").findOne();
			post = author.createPost(title="test post", body="here is some text");
			assert('DateDiff("s", localtime, post.createdAt) lte 1'); // allow 1 second between test value and inserted value
			assert('DateDiff("s", localtime, post.updatedAt) lte 1');
			transaction action="rollback";
		}
	}

	function test_epoch_timestamps() {
		transaction {
			epochtime = Now().getTime();
			model("Post").getClass().timeStampOnCreateProperty = "createdAtEpoch";
			model("Post").getClass().timeStampOnUpdateProperty = "updatedAtEpoch";
			model("Post").getClass().timeStampMode = "epoch";
			author = model("Author").findOne();
			post = author.createPost(title="test post", body="here is some text", createdAt=Now(), updatedAt=Now());
			assert('post.createdAtEpoch - epochtime lte 1000'); // allow 1 second between test value and inserted value
			assert('post.updatedAtEpoch - epochtime lte 1000'); // allow 1 second between test value and inserted value
			transaction action="rollback";
		}
	}

	function test_updatedAt_does_not_change_when_no_changes_to_model() {
		transaction {
			post = model("Post").findOne();
			orgUpdatedAt = post.properties().updatedAt;
			post.update();
			post.reload();
			newUpdatedAt = post.properties().updatedAt;
			assert('orgUpdatedAt eq newUpdatedAt');
			transaction action="rollback";
		}
	}

	function teardown() {
		// reset all changes to post model class
		model("Post").getClass().timeStampOnCreateProperty = "createdAt";
		model("Post").getClass().timeStampOnUpdateProperty = "updatedAt";
		model("Post").getClass().timeStampMode = "utc";
	}

}
