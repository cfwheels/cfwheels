component extends="wheels.tests.Test" {

	// this is of no real value.. but lays a foundation for testing sql formatting
	function test_sql_format() {
		actual = model("user").findAll(
			select = "id, username",
			where = "
				username IN ('foo', 'bar')
				AND id > '1'
		  ",
			returnAs = "sql"
		);

		// something like this is the dream
		expected = "SELECT users.id, users.username FROM users WHERE users.username IN (?, ?) AND users.id > ?";

		assert("actual eq expected");
	}

}
