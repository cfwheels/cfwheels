component extends="wheels.Test" output=false {

  /*
   * Executes once before the test suite runs
   */
  function beforeAll() {
    // save the original environment for overloading
    request.wheelsApplicationScope = Duplicate(application);
  }

  /*
   * Executes before every tests case if called from the package via super.superSetup()
   */
  function superSetup() {
    loc = {};
  }

  /*
   * Executes after every tests case if called from the package via super.superTeardown()
   */
  function superTeardown() {

  }

  /*
   * Executes once after the test suite runs
   */
  function afterAll() {
    // swap back the enviroment
  	StructAppend(application, request.wheelsApplicationScope, true);
  }
}
