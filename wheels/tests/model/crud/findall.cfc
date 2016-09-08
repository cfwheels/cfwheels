component extends="wheels.tests.Test" {

	function setup() {
		source = model("user").findAll(select="id,lastName", maxRows=3);
	}

	function test_maxrows_change_should_break_cache() {
		$cacheQueries = application.wheels.cacheQueries;
		application.wheels.cacheQueries = true;
		q = model("user").findAll(maxrows=1, cache=10);
		assert('q.recordCount IS 1');
		q = model("user").findAll(maxrows=2, cache=10);
		assert('q.recordCount IS 2');
		application.wheels.cacheQueries = $cacheQueries;
	}

	function test_in_operator_with_quoted_strings() {
		values = QuotedValueList(source.lastName);
		q = model("user").findAll(where="lastName IN (#values#)");
		assert('q.recordCount IS 3');
	}

	function test_in_operator_with_numbers() {
		values = ValueList(source.id);
		q = model("user").findAll(where="id IN (#values#)");
		assert('q.recordCount IS 3');
	}

	function test_custom_query_and_orm_query_in_transaction() {
		transaction {
			actual = model("user").findAll(select="id");
			expected = $query(
				datasource=application.wheels.dataSourceName,
				sql="SELECT id FROM users"
			);
		}
		assert("actual.recordCount eq expected.recordCount");
	}

	function test_in_operator_with_spaces() {
		authors = model("author").findAll(where="id != 0 AND id IN (1, 2, 3) AND firstName IN('Per', 'Tony') AND lastName IN ('Djurner', 'Petruzzi')");
		assert("authors.recordCount IS 2");
	}

}
