component extends="wheels.Test" output=false {

  /*
   * Executes once before the test suite runs
   */
  function beforeAll() {
    // populate the test database only on reload
  	if (StructKeyExists(url, "reload") && url.reload == true) {
  		include "populate.cfm";
  	}
  }

  /*
   * Executes before every tests case if called from the package via super.superSetup()
   */
  function setup() {

  }

  /*
   * Executes after every tests case if called from the package via super.superTeardown()
   */
  function teardown() {

  }

  /*
   * Executes once after the test suite runs
   */
  function afterAll() {
    // cleanup any dbmigrate sql
    local.sqlPath = Expandpath("wheels/tests/_assets/db/sql");
    if (DirectoryExists(local.sqlPath)) {
      directoryDelete(local.sqlPath, true);
    }
    directoryCreate(local.sqlPath);
  }
}
