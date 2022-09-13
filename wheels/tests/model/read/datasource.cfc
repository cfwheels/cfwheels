component extends="wheels.tests.Test" {

	function setup() {
		// we can only test h2 as the alt dsn.. the tables are not created in populate.cfm otherwise
		altDatasource = "wheelstestdb_h2";
		isTestable = application.wheels.dataSourceName neq altDatasource;
		if (!isTestable) {
			return;
		}
	}

	function db_setup() {
		// ensure the authors table exists in the alt datasource
		QueryExecute(
			sql = "
				CREATE TABLE IF NOT EXISTS authors
				(
					id int NOT NULL IDENTITY
					,firstname varchar(100) NOT NULL
					,lastname varchar(100) NOT NULL
					,PRIMARY KEY(id)
				);
			",
			options = {datasource = altDatasource}
		);
		firstName = "Troll";
		QueryExecute(
			sql = "INSERT INTO authors (firstName, lastName) VALUES ('#firstName#', 'Dolls');",
			options = {datasource = altDatasource}
		);
		finderArgs = {where = "firstName = '#firstName#'", datasource = altDatasource};
	}

	function test_findall_with_datasource_argument() {
		if (!isTestable) return;
		transaction {
			this.db_setup();
			defaultDBRows = model("Author").findAll(where = "firstName = '#firstName#'");
			actual = model("Author").findAll(argumentCollection = finderArgs);
			TransactionRollback();
		}
		assert("actual.recordCount");
		// sanity check that there are no rows in the default db
		assert("defaultDBRows.recordCount eq 0");
	}

	function test_findOne_with_datasource_argument() {
		if (!isTestable) return;
		transaction {
			this.db_setup();
			actual = model("Author").findOne(argumentCollection = finderArgs);
			TransactionRollback();
		}
		assert("IsObject(actual)");
	}

	function test_findFirst_with_datasource_argument() {
		if (!isTestable) return;
		transaction {
			this.db_setup();
			actual = model("Author").findFirst(argumentCollection = finderArgs);
			TransactionRollback();
		}
		assert("IsObject(actual)");
	}

	function test_findLastOne_with_datasource_argument() {
		if (!isTestable) return;
		transaction {
			this.db_setup();
			actual = model("Author").findLastOne(argumentCollection = finderArgs);
			TransactionRollback();
		}
		assert("IsObject(actual)");
	}

	function test_count_with_datasource_argument() {
		if (!isTestable) return;
		transaction {
			this.db_setup();
			actual = model("Author").count(argumentCollection = finderArgs);
			TransactionRollback();
		}
		assert("actual gt 0");
	}

	function test_exists_with_datasource_argument() {
		if (!isTestable) return;
		transaction {
			this.db_setup();
			actual = model("Author").exists(argumentCollection = finderArgs);
			TransactionRollback();
		}
		assert("actual eq true");
	}

}
