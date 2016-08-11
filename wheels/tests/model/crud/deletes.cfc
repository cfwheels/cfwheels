component extends="wheels.tests.Test" {

 	function test_delete() {
		transaction action="begin" {
			author = model("Author").findOne();
			author.delete();
			allAuthors = model("Author").findAll();
			transaction action="rollback";
		}
		assert('allAuthors.recordcount eq 6');
	}

 	function test_soft_delete() {
		transaction action="begin" {
			post = model("Post").findOne();
			post.delete();
			postsWithoutSoftDeletes = model("Post").findAll();
			postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true);
			transaction action="rollback";
		}
		assert('postsWithoutSoftDeletes.recordcount eq 4 AND postsWithSoftDeletes.recordcount eq 5');
	}

 	function test_permanent_delete() {
		transaction action="begin" {
			post = model("Post").findOne();
			post.delete(softDelete=false);
			postsWithoutSoftDeletes = model("Post").findAll();
			postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true);
			transaction action="rollback";
		}
		assert('postsWithoutSoftDeletes.recordcount eq 4 AND postsWithSoftDeletes.recordcount eq 4');
	}

 	function test_permanent_delete_of_soft_deleted_records() {
		transaction action="begin" {
			post = model("Post").findOne();
			post.delete();
			softDeletedPost = model("Post").findByKey(key=post.id, includeSoftDeletes=true);
			softDeletedPost.delete(includeSoftDeletes=true, softDelete=false);
			postsWithoutSoftDeletes = model("Post").findAll();
			postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true);
			transaction action="rollback";
		}
		assert('postsWithoutSoftDeletes.recordcount eq 4 AND postsWithSoftDeletes.recordcount eq 4');
	}

 	function test_delete_by_key() {
		transaction action="begin" {
			post = model("Author").findOne();
			model("Author").deleteByKey(post.id);
			allAuthors = model("Author").findAll();
			transaction action="rollback";
		}
		assert('allAuthors.recordcount eq 6');
	}

 	function test_soft_delete_by_key() {
		transaction action="begin" {
			post = model("Post").findOne();
			model("Post").deleteByKey(post.id);
			postsWithoutSoftDeletes = model("Post").findAll(includeSoftDeletes=false);
			postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true);
			transaction action="rollback";
		}
		assert('postsWithoutSoftDeletes.recordcount eq 4 AND postsWithSoftDeletes.recordcount eq 5');
	}

 	function test_permanent_delete_by_key() {
		transaction action="begin" {
			post = model("Post").findOne();
			model("Post").deleteByKey(key=post.id, softDelete=false);
			postsWithoutSoftDeletes = model("Post").findAll();
			postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true);
			transaction action="rollback";
		}
		assert('postsWithoutSoftDeletes.recordcount eq 4 AND postsWithSoftDeletes.recordcount eq 4');
	}

 	function test_permanent_delete_by_key_of_soft_deleted_records() {
		transaction action="begin" {
			post = model("Post").findOne();
			model("Post").deleteOne(where="id=#post.id#");
			model("Post").deleteOne(where="id=#post.id#", includeSoftDeletes=true, softDelete=false);
			postsWithoutSoftDeletes = model("Post").findAll();
			postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true);
			transaction action="rollback";
		}
		assert('postsWithoutSoftDeletes.recordcount eq 4 AND postsWithSoftDeletes.recordcount eq 4');
	}

 	function test_delete_one() {
		transaction action="begin" {
			model("Author").deleteOne();
			allAuthors = model("Author").findAll();
			transaction action="rollback";
		}
		assert('allAuthors.recordcount eq 6');
	}

 	function test_soft_delete_one() {
		transaction action="begin" {
			model("Post").deleteOne();
			postsWithoutSoftDeletes = model("Post").findAll();
			postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true);
			transaction action="rollback";
		}
		assert('postsWithoutSoftDeletes.recordcount eq 4 AND postsWithSoftDeletes.recordcount eq 5');
	}

 	function test_permanent_delete_one() {
		transaction action="begin" {
			model("Post").deleteOne(softDelete=false);
			postsWithoutSoftDeletes = model("Post").findAll();
			postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true);
			transaction action="rollback";
		}
		assert('postsWithoutSoftDeletes.recordcount eq 4 AND postsWithSoftDeletes.recordcount eq 4');
	}

 	function test_permanent_delete_one_of_soft_deleted_records() {
		transaction action="begin" {
			post = model("Post").findOne();
			model("Post").deleteOne(where="id=#post.id#");
			model("Post").deleteOne(where="id=#post.id#", includeSoftDeletes=true, softDelete=false);
			postsWithoutSoftDeletes = model("Post").findAll();
			postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true);
			transaction action="rollback";
		}
		assert('postsWithoutSoftDeletes.recordcount eq 4 AND postsWithSoftDeletes.recordcount eq 4');
	}

 	function test_delete_all() {
		transaction action="begin" {
			model("Author").deleteAll();
			allAuthors = model("Author").findAll();
			transaction action="rollback";
		}
		assert('allAuthors.recordcount eq 0');
	}

 	function test_soft_delete_all() {
		transaction action="begin" {
			model("Post").deleteAll();
			postsWithoutSoftDeletes = model("Post").findAll();
			postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true);
			transaction action="rollback";
		}
		assert('postsWithoutSoftDeletes.recordcount eq 0 AND postsWithSoftDeletes.recordcount eq 5');
	}

 	function test_permanent_delete_all() {
		transaction action="begin" {
			model("Post").deleteAll(softDelete=false);
			postsWithoutSoftDeletes = model("Post").findAll();
			postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true);
			transaction action="rollback";
		}
		assert('postsWithoutSoftDeletes.recordcount eq 0 AND postsWithSoftDeletes.recordcount eq 0');
	}

 	function test_permanent_delete_all_of_soft_deleted_records() {
		transaction action="begin" {
			model("Post").deleteAll();
			model("Post").deleteAll(includeSoftDeletes=true, softDelete=false);
			postsWithoutSoftDeletes = model("Post").findAll();
			postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true);
			transaction action="rollback";
		}
		assert('postsWithoutSoftDeletes.recordcount eq 0 AND postsWithSoftDeletes.recordcount eq 0');
	}

}
