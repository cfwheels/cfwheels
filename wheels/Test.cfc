<cfscript>
/*
  Base component for rapidly writing/running test cases.

  Terminology
  -----------
  -	A Test Package is a collection of Test Cases that tests the functionality
    of an application/service/whatever.

  -	A Test Case is a collection of Tests to apply to a particular CF component,
    tag or include file.

  - 	A Test is a sequence of calls to the code being tested and Assertions about
    the results we get from the code.

  -	An Assertion is a statement we make about the results we get that should
    evaluate to true if the tested code is working properly.

  How are these things represented in test code using this file?
  --------------------------------------------------------------
  -	A Test Package is a directory that can be referred to by a CF mapping, and
    ideally outside the web root for security.

  -	A Test Case is a CF component in that directory that extends this component.

  -	A Test is a method in one of these components.  The method name should start with
    the word "test", it should require no arguments and return void.  Any setup or
    clearup code common to all test functions can be added to optional setup() and
    teardown() methods, which again take no arguments and return void.

    Tests in each Test Case are run in alphabetical order.  If you want your tests
    to run in a particular order you could name them test01xxx, test02yyy, etc.

  -	An Assertion is a call to the assert() method (inherited from this component) inside
    a test method.  assert() takes a string argument, an expression (see ColdFusion
    evaluate() documentation) that evaluates to true or false.  If false, a "failure"
    is recorded for the test case and the test case fails.  assert() tries to include
    the value of any variables it finds in the expression.

    If there are specific variable values you would like included in the failure message,
    pass them as additional string arguments to assert().  Multiple variables can be
    listed in a single space-delimited string if this is convenient.

    For more complicated assertions you may call the fail() method directly, which takes
    a single message string as an argument.

  -	If an uncaught exception is thrown an "error" is recorded for the Test Case and the
    Test Case fails.

  Running tests
  -------------
  Assuming this file is under a com.rocketboots.rocketunit cf mapping, you have some test cases
  under a com.myco.myapp.sometestpackage cf mapping, and a test case SomeTestCase.cfc in that
  mapping...

  To run a test package:

    <cfset test = createObject("component", "com.rocketboots.rocketunit.Test")>
    <cfset test.runTestPackage("test.com.myco.myapp.sometestpackage")>


  To run a specific test case:

    <cfset test = createObject("component", "test.com.myco.myapp.sometestpackage.SomeTestCase")>
    <cfset test.runTest()>

  To see human readable output after running a test:

    <cfoutput>#test.HTMLFormatTestResults()#</cfoutput>

  The test results are available in the request.test structure.  If you would like to
  use a different key in request (as we do for the rocketunit self-tests) for the results
  you can pass the key name as a second argument to the run method.

  You can call run() multiple times and the test results will be combined.

  If you wish to reset the test results before calling run() again, call resetTestResults().


  Copyright 2007 RocketBoots Pty Limited - http://www.rocketboots.com.au

    This file is part of RocketUnit.

    RocketUnit is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    RocketUnit is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with RocketUnit; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

  @version $Id: Test.cfc 167 2007-04-12 07:50:15Z robin $
*/

component output=false {

  // variables that are used by the testing framework itself
  TESTING_FRAMEWORK_VARS = {};
  TESTING_FRAMEWORK_VARS.WHEELS_TESTS_BASE_COMPONENT_PATH  = "";
  TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH = "";
  TESTING_FRAMEWORK_VARS.RUNNING_TEST = "";

  // used to hold debug information for display
  if (!StructKeyExists(request, "TESTING_FRAMEWORK_DEBUGGING")) {
    request["TESTING_FRAMEWORK_DEBUGGING"] = {};
  }

  /*
    Called from a test function.  If expression evaluates to false,
    record a failure against the test.

    @param	expression	String containing CFML expression to evaluate
    @param	2..n		Optional. String(s) containing space-delimited list
              of variables to evaluate and include in the
              failure message to help determine cause of failed
              assertion.
   */

  public void function assert(required string expression) {
    var token = "";
 		var tokenValue = "";
 		var message = "assert failed: #expression#";
 		var newline = chr(10) & chr(13);
 		var i = "";
 		var evaluatedTokens = "";

    if (! evaluate(expression)) {

      for (expression in arguments) {

 				evaluatedTokens = {};

 				/*
 					Double pass of expressions with different delimiters so that for expression "a(b) or c[d]",
 					"a(b)", "c[d]", "b" and "d" are evaluated.  Do not evaluate any expression more than once.
 				*/
        for (token in listToArray("#expression# #reReplace(expression, "[([\])]", " ")#", " +=-*/%##")) {

 					if (! structKeyExists(evaluatedTokens, token)) {

 						evaluatedTokens[token] = true;
 						tokenValue = "__INVALID__";

 						if (! (isNumeric(token) or isBoolean(token))) {
              try {
                tokenValue = evaluate(token);
              } catch(expression e) {
              }
 						}

 						/*
 							Format token value according to type
 						*/
 						if ((! isSimpleValue(tokenValue)) or (tokenValue neq "__INVALID__")) {

 							if (isSimpleValue(tokenValue)) {
 								if (! (isNumeric(tokenValue) or isBoolean(tokenValue))) {
 									tokenValue ="'#tokenValue#'";
 								}
 							} else {
 								if (isArray(tokenValue)) {
 									tokenValue = "array of #arrayLen(tokenValue)# items";
 								} else if (isStruct(tokenValue)) {
 									tokenValue = "struct with #structCount(tokenValue)# members";
 								} else if (IsCustomFunction(tokenValue)) {
 									tokenValue = "UDF";
 								}
 							}
 							message = message & newline & token & " = " & tokenValue;
 						}
 					}
 				}
 			}
 			fail(message);
 		}
 	}

  /*
		Called from a test function to cause the test to fail.
    Will throw an exception resulting in a test failure along with an option message.

		@param message	Message to record in test results against failure.
	*/
  public void function fail(string message="") {
    /*
			run() interprets exception with this errorcode as a "Failure".
			All other errorcodes cause are interpreted as an "Error".
		*/
		throw(errorcode="__FAIL__", message="#HTMLEditFormat(message)#");
  }

  /*
   Used to examine an expression. any overloaded arguments get passed to
   cfdump's attributeCollection

   @param	expression	The expression to examine
   @param display Optional. boolean.  Whether to display the debug call.
            false returns without outputting anything into the buffer.
            good when you want to leave the debug command in the test for
            later purposes, but don't want it to display
   */
  public any function debug(required string expression, boolean display=true) {
    var attributeArgs = {};
		var dump = "";

		if (!arguments.display) {
			return;
		}

    dump(var=arguments, label="arguments");

		attributeArgs["var"] = evaluate(arguments.expression);

		structDelete(arguments, "expression");
		structDelete(arguments, "display");
    structAppend(attributeArgs, arguments, true);

    savecontent variable="dump" {
      dump(attributeCollection=attributeArgs);
    }

		if (! StructKeyExists(request["TESTING_FRAMEWORK_DEBUGGING"], TESTING_FRAMEWORK_VARS.RUNNING_TEST)) {
			request["TESTING_FRAMEWORK_DEBUGGING"][TESTING_FRAMEWORK_VARS.RUNNING_TEST] = [];
		}
		arrayAppend(request["TESTING_FRAMEWORK_DEBUGGING"][TESTING_FRAMEWORK_VARS.RUNNING_TEST], dump);
  }

  /*
    Catches a raised error and returns the error type. great if you want to
    test that a certain exception will be raised.
   */
  public string function raised(required string expression) {
    try {
      evaluate(arguments.expression);
    } catch(any e) {
      return trim(e.type);
    }
    return "";
  }

  /*
    Run all the tests in a component.

    @param resultKey	Key to store distinct test result sets under in
              request scope, defaults to "test"
    @returns true if no errors
   */
  public boolean function $runTest(string resultKey="test", string testname="") {
    var key = "";
		var keyList = "";
		var time = "";
		var testCase = "";
		var status = "";
		var result = "";
		var message = "";
		var numTests = 0;
		var numTestFailures = 0;
		var numTestErrors = 0;
		var newline = chr(10) & chr(13);
    var func = "";
    var tagContext = "";
    var context = "";

		/*
			Check for and if necessary set up the structure to store test results
		*/
		if (! StructKeyExists(request, resultKey)) {
			$resetTestResults(resultKey);
		}

		testCase = getMetadata(this).name;

		/*
			Iterate through the members of the this scope in alphabetical order,
			invoking methods starting in "test".  Wrap with calls to setup()
			and teardown() if provided.
		*/

		functions = getMetadata(this).functions;
    for (func in functions) {
			keyList = ListAppend(keyList, func.name);
		};
		keyList = ListSort(keyList, "textnocase", "asc");

    for (key in listToArray(keyList)) {

			/* keep track of the test name so we can display debug information */
			TESTING_FRAMEWORK_VARS.RUNNING_TEST = key;

			if ((left(key, 4) eq "test" and isCustomFunction(this[key])) and (!len(arguments.testname) or (len(arguments.testname) and arguments.testname eq key))) {

				time = getTickCount();

				if (structKeyExists(this, "setup")) {
					setup();
				}

				try {

					message = "";
          invoke(this, key);
					status = "Success";
					request[resultkey].numSuccesses = request[resultkey].numSuccesses + 1;

        } catch(any e) {

					message = e.message;

					if (e.ErrorCode eq "__FAIL__") {

						/*
							fail() throws __FAIL__ exception
						*/
						status = "Failure";
						request[resultkey].ok = false;
						request[resultkey].numFailures = request[resultkey].numFailures + 1;
						numTestFailures = numTestFailures + 1;

					} else {

						/*
							another exception thrown
						*/
						status = "Error";
            if (ArrayLen(e.tagContext)) {
            	template = "#ListLast(e.tagContext[1].template, "/")# line #e.tagContext[1].line#";
              tagContext = "<ul>" & newline;
              for (context in e.tagContext) {
                tagContext = tagContext & '<li>#context.template# line #context.line#</li>' & newline;
              };
              tagContext = tagContext = "</ul>";
            } else {
            	template = "";
              tagContext = "[Unknown tagContext]";
            }

	          if (Len(template)) {
							message = message & newline & template;
						}
            if (StructKeyExists(e, "sql") and Len(e.sql)) {
            	message = message & newline & newline & e.sql;
            }
            if (Len(e.extendedInfo)) {
							message = message & newline & newLine & e.extendedInfo;
						}
            message = message & newline & newline & tagContext;
            if (Len(e.detail)) {
            	message = message & newline & newline & e.detail;
            }
						request[resultkey].ok = false;
						request[resultkey].numErrors = request[resultkey].numErrors + 1;
						numTestErrors = numTestErrors + 1;

					}
				}

				if (structKeyExists(this, "teardown")) {
					teardown();
				}

				time = getTickCount() - time;

				/*
					Record test results
				*/
				result = {};
				result.testCase = testCase;
				result.testName = key;
				result.time = time;
				result.status = status;
				result.message = message;
				arrayAppend(request[resultkey].results, result);

				request[resultkey].numTests = request[resultkey].numTests + 1;
				numTests = numTests + 1;

			}
		};

		result = {};
		result.testCase = testCase;
		result.numTests = numTests;
		result.numFailures = numTestFailures;
		result.numErrors = numTestErrors;
		arrayAppend(request[resultkey].summary, result);

		request[resultkey].numCases = request[resultkey].numCases + 1;
		request[resultkey].end = now();

		return numTestErrors eq 0;

  }

  /*
    Clear results.

    @param resultKey	Key to store distinct test result sets under in
              request scope, defaults to "test"
   */

  public void function $resetTestResults(string resultKey="test") {
    request[resultkey] = {};
		request[resultkey].begin = now();
		request[resultkey].ok = true;
		request[resultkey].numCases = 0;
		request[resultkey].numTests = 0;
		request[resultkey].numSuccesses = 0;
		request[resultkey].numFailures = 0;
		request[resultkey].numErrors = 0;
		request[resultkey].summary = [];
		request[resultkey].results = [];
  }

  /*
    Report test results at overall, test case and test level, highlighting
    failures and errors.

    @param resultKey	Key to retrive distinct test result sets from in
              request scope, defaults to "test"
    @returns			HTML formatted test results
   */

  public any function $results(string resultKey="test") {
    var loc = {};
		loc.rv = false;
    if (structkeyexists(request, resultkey)) {
			request[resultkey].path = TESTING_FRAMEWORK_VARS.WHEELS_TESTS_BASE_COMPONENT_PATH;

			loc.summaryLength = ArrayLen(request[resultkey].summary);
      for (loc.i=1; loc.i <=loc.summaryLength; loc.i++) {
				request[resultkey].summary[loc.i].cleanTestCase = $cleanTestCase(request[resultkey].summary[loc.i].testCase);
				request[resultkey].summary[loc.i].packageName = $cleanTestPath(request[resultkey].summary[loc.i].testCase);
			};

      loc.resultsLength = ArrayLen(request[resultkey].results);
			for (loc.i=1; loc.i <=loc.resultsLength; loc.i++) {
				request[resultkey].results[loc.i].cleanTestCase = $cleanTestCase(request[resultkey].results[loc.i].testCase);
				request[resultkey].results[loc.i].cleanTestName = $cleanTestName(request[resultkey].results[loc.i].testName);
				request[resultkey].results[loc.i].packageName = $cleanTestPath(request[resultkey].results[loc.i].testCase);
			};

			loc.rv = request[resultkey];
		}
		return loc.rv;
  }

  /***********************
   * Wheels Helper Methods
   ***********************/

  // include main wheels functions & plugins in tests by default
  include "global/functions.cfm";
  include "plugins/injection.cfm";

  /*
   * The function wheels uses to run tests
   */
  public any function $wheelsRunner(struct options={}) {
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
  		loc.instance = CreateObject("component", loc.row.package);
      loc.instance.$runTest(loc.resultKey, loc.test);
  	};
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
    return true;
  }

  /*
   * removes the base test directory from the test name to make them prettier and more readable
   * TODO: value of TESTING_FRAMEWORK_VARS.WHEELS_TESTS_BASE_COMPONENT_PATH should be an argument so it can be passed in for testing
   */
  public string function $cleanTestCase(
    required string name,
    string path=TESTING_FRAMEWORK_VARS.WHEELS_TESTS_BASE_COMPONENT_PATH
  ) {
    return ListChangeDelims(Replace(arguments.name, arguments.path, ""), ".", ".");
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

}
</cfscript>
