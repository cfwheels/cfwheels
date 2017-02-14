component extends="wheels.tests.Test" {

	function setup() {
		dbmigrate = CreateObject("component", "wheels.dbmigrate.dbmigrate").init(
			migratePath="wheels/tests/_assets/db/migrate/"
		);
	}

	function test_getAvailableMigrations_returns_expected_value() {
		if(!application.testenv.isOracle){
			available = dbmigrate.getAvailableMigrations();
			actual = "";
			for (local.i in available) {
				actual = ListAppend(actual, local.i.version);
			};
			expected = "001,002,003";
			assert("actual eq expected");
		}
	}
}
