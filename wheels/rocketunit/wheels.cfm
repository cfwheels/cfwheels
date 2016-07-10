<cfscript>
/*
 * Catches a raised error and returns the error type.
 * Great if you want to test that a certain exception will be raised.
 * (ported from RocketUnit 1 for backwards compatibility)
 */
public any function raised(required string expression) {
	try {
		Evaluate(arguments.expression)
	} catch(any e) {
		return Trim(e.type);
	}
	return "";
}

public any function $WheelsRunner(struct options={}) {
	var loc = {};
	// the key in the request scope that will contain the test results
	loc.resultKey = "WheelsTests";
	// save the original environment for overloading
	loc.savedenv = Duplicate(application);
	// not only can we specify the package, but also the test we want to run
	loc.test = "";
	if (StructKeyExists(arguments.options, "test") && Len(arguments.options.test)) {
		loc.test = arguments.options.test;
	}
	loc.paths = $resolvePaths(arguments.options);
	loc.packages = $listTestPackages(arguments.options, loc.paths.test_filter);
	// run tests
	for(loc.row in loc.packages) {
		instance = CreateObject("component", loc.row.package).init(loc.resultKey);
    instance.runTests();
	}
	// swap back the enviroment
	StructAppend(application, loc.savedenv, true);
	// return the results
	return $results(loc.resultKey);
}

/*
 * Args:
 * component: path to the component you want to check as a valid test
 * shouldExtend: if the component should extend a base component to be a valid test
 */
public boolean function $isValidTest(
	required string component,
	string shouldExtend="Test"
) {
	var loc = {};
	if (Len(arguments.shouldExtend)) {
    loc.metadata = GetComponentMetaData(arguments.component);
		if (! StructKeyExists(loc.metadata, "extends") or loc.metadata.extends.fullname does not contain arguments.shouldExtend) {
			return false;
		}
  }
  return true
}

/*
 * removes the base test directory from the test name to make them prettier and more readable
 */
public string function $cleanTestCase(required string name) {
	return ListChangeDelims(Replace(arguments.name, TESTING_FRAMEWORK_VARS.WHEELS_TESTS_BASE_COMPONENT_PATH, ""), ".", ".");
}

/*
 * cleans up the test name so they are more readable
 */
public string function $cleanTestName(required string name) {
	return humanize(Trim(REReplaceNoCase(ListRest(arguments.name, "_"), "_|-", " ", "all")));
}

/*
 * cleans up the test path
 */
public string function $cleanTestPath(required string path) {
	return ListChangeDelims(Replace(arguments.path, TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH, ""), ".", ".");
}

/*
 * this resolves all the paths needed to run the tests
 */
public struct function $resolvePaths(struct options={}) {

  var loc = {};
  loc.rv = {};

  // default test type
  loc.type = "core";
  // testfilter
  loc.rv.test_filter = "*";
  // by default we run all packages, however they can specify to run a specific package of tests
  loc.package = "";

  // if they specified a package we should only run that
	if (StructKeyExists(arguments.options, "package") && Len(arguments.options.package)) {
		loc.package = arguments.options.package;
	}
  // overwrite the default test type if passed
	if (structkeyexists(arguments.options, "type") and len(arguments.options.type)) {
		loc.type = arguments.options.type;
	}

  // which tests to run
  if (loc.type eq "core") {
    // core tests
    TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH = application.wheels.wheelsComponentPath;
  } else if (loc.type eq "app") {
    // app tests
    TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH = application.wheels.rootComponentPath;
  } else {
    // specific plugin tests
    TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH = application.wheels.rootComponentPath;
    TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH = ListAppend(TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH, "#application.wheels.pluginComponentPath#.#loc.type#", ".");
  }

  TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH = ListAppend(TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH, "tests", ".");

  // add the package if specified
  loc.rv.test_path = listappend("#TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH#", loc.package, ".");

  // clean up testpath
  loc.rv.test_path = listchangedelims(loc.rv.test_path, ".", "./\");

  // convert to regular path
  loc.rv.relative_root_test_path = "/" & listchangedelims(TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH, "/", ".");
  loc.rv.full_root_test_path = expandpath(loc.rv.relative_root_test_path);
  loc.rv.relative_test_path = "/" & listchangedelims(loc.rv.test_path, "/", ".");
  loc.rv.full_test_path = expandPath(loc.rv.relative_test_path);

	if (! DirectoryExists(loc.rv.full_test_path)) {
		if (FileExists(loc.rv.full_test_path & ".cfc")) {
      loc.rv.test_filter = reverse(listfirst(reverse(loc.rv.test_path), "."));
      loc.rv.test_path = reverse(listrest(reverse(loc.rv.test_path), "."));
      loc.rv.relative_test_path = "/" & listchangedelims(loc.rv.test_path, "/", ".");
      loc.rv.full_test_path = expandPath(loc.rv.relative_test_path);
    } else {
      throw(
        type="Wheels.Testing",
        message="Cannot find test package or single test",
        detail="In order to run test you must supply a valid test package or single test file to run"
			);
    }
  }

  // for test results display
  TESTING_FRAMEWORK_VARS.WHEELS_TESTS_BASE_COMPONENT_PATH = loc.rv.test_path;

  return loc.rv;
}

/*
 * returns a query containing all the test to run and their directory path
 */
public query function $listTestPackages(struct options={}, string filter="*") {

  var loc = {};
  loc.rv = QueryNew("package","Varchar");

  loc.paths = $resolvePaths(arguments.options);
  $initialseTestEnvironment(loc.paths, arguments.options);

	loc.packages = DirectoryList(loc.paths.full_test_path, true, "query", "#arguments.filter#.cfc");
	for (loc.package in loc.packages) {
    loc.packageName = ListChangeDelims(RemoveChars(loc.package.directory, 1, Len(loc.paths.full_test_path)), ".", "\/");
		// directories that begin with an underscore are ignored
		if (! ReFindNoCase("(^|\.)_", loc.packageName)) {
      loc.packageName = ListPrepend(loc.packageName, loc.paths.test_path, ".");
      loc.packageName = ListAppend(loc.packageName, ListFirst(loc.package.name, "."), ".");
      // ignore invalid packages and package names that begin with underscores
			if (Left(loc.package.name, 1) != "_" && $isValidTest(loc.packageName)) {
				QueryAddRow(loc.rv);
        QuerySetCell(loc.rv, "package", loc.packageName);
			}
    }
  };
  return loc.rv;
}

/*
 * Initialises the test environment and populates test database
 */
public void function $initialseTestEnvironment(
	required struct paths,
	required struct options
) {
	if (FileExists(arguments.paths.full_root_test_path & "/env.cfm")) {
		include "#arguments.paths.relative_root_test_path & '/env.cfm'#";
	}
	// populate the test database only on reload
	if (StructKeyExists(arguments.options, "reload") && arguments.options.reload == true && FileExists(arguments.paths.full_root_test_path & "/populate.cfm")) {
		include "#arguments.paths.relative_root_test_path & '/populate.cfm'#";
	}

}

/*
 * Tweaks the RocketUnit results
 */
public any function $results(string resultKey="test") {
	var loc = {};
	loc.rv = false;

	if (StructKeyExists(request, resultkey)) {

		request[resultkey].path = TESTING_FRAMEWORK_VARS.WHEELS_TESTS_BASE_COMPONENT_PATH;

		loc.cases = ArrayLen(request[resultkey].cases);
		for (loc.i = 1; loc.i <= loc.cases; loc.i++) {
			request[resultkey].cases[loc.i].cleanTestCase = $cleanTestCase(request[resultkey].cases[loc.i].testCase);
			request[resultkey].cases[loc.i].packageName = $cleanTestPath(request[resultkey].cases[loc.i].testCase);
		}

    loc.tests = ArrayLen(request[resultkey].tests);
		for (loc.i = 1; loc.i <= loc.tests; loc.i++) {
			request[resultkey].tests[loc.i].cleanTestCase = $cleanTestCase(request[resultkey].tests[loc.i].testCase);
			request[resultkey].tests[loc.i].cleanTestName = $cleanTestName(request[resultkey].tests[loc.i].testName);
			request[resultkey].tests[loc.i].packageName = $cleanTestPath(request[resultkey].tests[loc.i].testCase);
		}
		loc.rv = request[resultkey];
	}
	return loc.rv;
}

// include main wheels functions & plugins in tests by default
include template="../global/functions.cfm";
include template="../plugins/injection.cfm";
</cfscript>
