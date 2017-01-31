component extends="wheels.tests.Test" {

	function test_from_clause() {
		result = model("author").$fromClause(include="");
		assert("result IS 'FROM authors'");
	}

	function test_from_clause_with_mapped_table() {
		model("author").table("tbl_authors");
		result = model("author").$fromClause(include="");
		model("author").table("authors");
		assert("result IS 'FROM tbl_authors'");
	}

	function test_from_clause_with_include() {
		result = model("author").$fromClause(include="posts");
		assert("result IS 'FROM authors LEFT OUTER JOIN posts ON authors.id = posts.authorid AND posts.deletedat IS NULL'");
	}

/*
test:
inner/outer join
composite keys joining
mapped pkeys
*/

}
