component extends="wheels.tests.Test" {

	function test_numeric_operators() {
		operators = ListToArray("=,<>,!=,<,<=,!<,>,>=,!>");
		for (i in operators) {
			check = "Len(result[2]) IS (11+#Len(i)#) AND ArrayLen(result) IS 3 AND result[3].type IS 'cf_sql_integer' AND Right(result[2], #Len(i)#) IS '#i#'";
			result = model("author").$whereClause(where="id#i#0");
			assert(check);
			result = model("author").$whereClause(where="id#i# 11");
			assert(check);
			result = model("author").$whereClause(where="id #i#999");
			assert(check);
		};
	}

	function test_in_like_operators() {
			result = model("author").$whereClause(where="id IN (1,2,3)");
			assert("Right(result[2], 2) IS 'IN'");
			result = model("author").$whereClause(where="id NOT IN (1,2,3)");
			assert("Right(result[2], 6) IS 'NOT IN'");
			result = model("author").$whereClause(where="lastName LIKE 'Djurner'");
			assert("Right(result[2], 4) IS 'LIKE'");
			result = model("author").$whereClause(where="lastName NOT LIKE 'Djurner'");
			assert("Right(result[2], 8) IS 'NOT LIKE'");
	}

	function test_floats() {
		result = model("post").$whereClause(where="averagerating IN(3.6,3.2)");
		assert('arraylen(result) gte 4');
		assert('isstruct(result[4])');
		assert('result[4].datatype eq "float" OR result[4].datatype eq "float8" OR result[4].datatype eq "double" OR result[4].datatype eq "number"');
		result = model("post").$whereClause(where="averagerating NOT IN(3.6,3.2)");
		assert('arraylen(result) gte 4');
		assert('isstruct(result[4])');
		assert('result[4].datatype eq "float" OR result[4].datatype eq "float8" OR result[4].datatype eq "double" OR result[4].datatype eq "number"');
		result = model("post").$whereClause(where="averagerating = 3.6");
		assert('arraylen(result) gte 4');
		assert('isstruct(result[4])');
		assert('result[4].datatype eq "float" OR result[4].datatype eq "float8" OR result[4].datatype eq "double" OR result[4].datatype eq "number"');
	}

	function test_is_null() {
		result = model("post").$whereClause(where="averagerating IS NULL");
		assert('arraylen(result) gte 4');
		assert('isstruct(result[4])');
		result = model("post").$whereClause(where="averagerating IS NOT NULL");
		assert('arraylen(result) gte 4');
		assert('isstruct(result[4])');
		assert('result[4].datatype eq "float" OR result[4].datatype eq "float8" OR result[4].datatype eq "double" OR result[4].datatype eq "number"');
	}
}
