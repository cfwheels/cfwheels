component extends="wheels.tests.Test" {

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

}
