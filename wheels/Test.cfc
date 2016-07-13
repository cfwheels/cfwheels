<cfcomponent>
	<!---
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
	--->

  <!--- variables that are used by the testing framework itself --->
  <cfset TESTING_FRAMEWORK_VARS = {}>
  <cfset TESTING_FRAMEWORK_VARS.WHEELS_TESTS_BASE_COMPONENT_PATH  = "">
  <cfset TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH = "">
  <cfset TESTING_FRAMEWORK_VARS.RUNNING_TEST = "">

	<!--- used to hold debug information for display --->
	<cfif !StructKeyExists(request, "TESTING_FRAMEWORK_DEBUGGING")>
		<cfset request["TESTING_FRAMEWORK_DEBUGGING"] = {}>
	</cfif>

	<!---
		Called from a test function.  If expression evaluates to false,
		record a failure against the test.

		@param	expression	String containing CFML expression to evaluate
		@param	2..n		Optional. String(s) containing space-delimited list
							of variables to evaluate and include in the
							failure message to help determine cause of failed
							assertion.
	--->
	<cffunction name="assert" returntype="void" output="false" hint="evaluates an expression">
		<cfargument type="string" name="expression" required=true>

		<cfset var token = "">
		<cfset var tokenValue = "">
		<cfset var message = "assert failed: #expression#">
		<cfset var newline = chr(10) & chr(13)>
		<cfset var i = "">
		<cfset var evaluatedTokens = "">

		<cfif not evaluate(expression)>

			<cfloop from="1" to="#arrayLen(arguments)#" index="i">

				<cfset expression = arguments[i]>
				<cfset evaluatedTokens = structNew()>

				<!---
					Double pass of expressions with different delimiters so that for expression "a(b) or c[d]",
					"a(b)", "c[d]", "b" and "d" are evaluated.  Do not evaluate any expression more than once.
				--->
				<cfloop list="#expression# #reReplace(expression, "[([\])]", " ")#" delimiters=" +=-*/%##" index="token">

					<cfif not structKeyExists(evaluatedTokens, token)>

						<cfset evaluatedTokens[token] = true>
						<cfset tokenValue = "__INVALID__">

						<cfif not (isNumeric(token) or isBoolean(token))>

							<cftry>
								<cfset tokenValue = evaluate(token)>
							<cfcatch type="expression"/>
							</cftry>

						</cfif>

						<!---
							Format token value according to type
						--->
						<cfif (not isSimpleValue(tokenValue)) or (tokenValue neq "__INVALID__")>

							<cfif isSimpleValue(tokenValue)>
								<cfif not (isNumeric(tokenValue) or isBoolean(tokenValue))>
									<cfset tokenValue ="'#tokenValue#'">
								</cfif>
							<cfelse>
								<cfif isArray(tokenValue)>
									<cfset tokenValue = "array of #arrayLen(tokenValue)# items">
								<cfelseif isStruct(tokenValue)>
									<cfset tokenValue = "struct with #structCount(tokenValue)# members">
								<cfelseif IsCustomFunction(tokenValue)>
									<cfset tokenValue = "UDF">
								</cfif>
							</cfif>

							<cfset message = message & newline & token & " = " & tokenValue>

						</cfif>

					</cfif>

				</cfloop>

			</cfloop>

			<cfset fail(message)>

		</cfif>

	</cffunction>

	<!---
		Called from a test function to cause the test to fail.

		@param message	Message to record in test results against failure.
	--->
	<cffunction name="fail" returntype="void" hint="will throw an exception resulting in a test failure along with an option message.">
		<cfargument type="string" name="message" required="false" default="">

		<!---
			run() interprets exception with this errorcode as a "Failure".
			All other errorcodes cause are interpreted as an "Error".
		--->
		<cfthrow errorcode="__FAIL__" message="#HTMLEditFormat(message)#">

	</cffunction>

	<cffunction name="debug" returntype="Any" output="false" hint="used to examine an expression. any overloaded arguments get passed to cfdump's attributeCollection">
		<cfargument name="expression" type="string" required="true" hint="the expression to examine.">
		<cfargument name="display" type="boolean" required="false" default="true" hint="whether to display the debug call. false returns without outputting anything into the buffer. good when you want to leave the debug command in the test for later purposes, but don't want it to display">
		<cfset var attributeArgs = {}>
		<cfset var dump = "">

		<cfif !arguments.display>
			<cfreturn>
		</cfif>

		<cfset attributeArgs["var"] = "#evaluate(arguments.expression)#">

		<cfset structdelete(arguments, "expression")>
		<cfset structdelete(arguments, "display")>
		<cfset structappend(attributeArgs, arguments, true)>

		<cfsavecontent variable="dump">
		<cfdump attributeCollection="#attributeArgs#">
		</cfsavecontent>

		<cfif !StructKeyExists(request["TESTING_FRAMEWORK_DEBUGGING"], TESTING_FRAMEWORK_VARS.RUNNING_TEST)>
			<cfset request["TESTING_FRAMEWORK_DEBUGGING"][TESTING_FRAMEWORK_VARS.RUNNING_TEST] = []>
		</cfif>
		<cfset arrayAppend(request["TESTING_FRAMEWORK_DEBUGGING"][TESTING_FRAMEWORK_VARS.RUNNING_TEST], dump)>
	</cffunction>

	<cffunction name="raised" returntype="string" output="false" hint="catches an raised error and returns the error type. great if you want to test that a certain exception will be raised.">
		<cfargument type="string" name="expression" required="true">
		<cftry>
			<cfset evaluate(arguments.expression)>
			<cfcatch type="any">
				<cfreturn trim(cfcatch.type)>
			</cfcatch>
		</cftry>
		<cfreturn "">
	</cffunction>

	<!---
		Run all the tests in a component.

		@param resultKey	Key to store distinct test result sets under in
							request scope, defaults to "test"
		@returns true if no errors
	--->
	<cffunction name="$runTest" returntype="boolean" output="true">
		<cfargument name="resultKey" type="string" required="false" default="test">
		<cfargument name="testname" type="string" required="false" default="">

		<cfset var key = "">
		<cfset var keyList = "">
		<cfset var time = "">
		<cfset var testCase = "">
		<cfset var status = "">
		<cfset var result = "">
		<cfset var message = "">
		<cfset var numTests = 0>
		<cfset var numTestFailures = 0>
		<cfset var numTestErrors = 0>
		<cfset var newline = chr(10) & chr(13)>

		<!---
			Check for and if necessary set up the structure to store test results
		--->
		<cfif !StructKeyExists(request, resultKey)>
			<cfset $resetTestResults(resultKey)>
		</cfif>

		<cfset testCase = getMetadata(this).name>

		<!---
			Iterate through the members of the this scope in alphabetical order,
			invoking methods starting in "test".  Wrap with calls to setup()
			and teardown() if provided.
		--->

		<cfset functions = getMetadata(this).functions>
		<cfloop from="1" to="#ArrayLen(functions)#" index="i">
			<cfset keyList = ListAppend(keyList, functions[i].name)>
		</cfloop>
		<cfset keyList = ListSort(keyList, "textnocase", "asc")>

		<cfloop list="#keyList#" index="key">

			<!--- keep track of the test name so we can display debug information --->
			<cfset TESTING_FRAMEWORK_VARS.RUNNING_TEST = key>

			<cfif (left(key, 4) eq "test" and isCustomFunction(this[key])) and (!len(arguments.testname) or (len(arguments.testname) and arguments.testname eq key))>

				<cfset time = getTickCount()>

				<cfif structKeyExists(this, "setup")>
					<cfset setup()>
				</cfif>

				<cftry>

					<cfset message = "">
					<cfinvoke method="#key#">
					<cfset status = "Success">
					<cfset request[resultkey].numSuccesses = request[resultkey].numSuccesses + 1>

				<cfcatch type="any">

					<cfset message = cfcatch.message>

					<cfif cfcatch.ErrorCode eq "__FAIL__">

						<!---
							fail() throws __FAIL__ exception
						--->
						<cfset status = "Failure">
						<cfset request[resultkey].ok = false>
						<cfset request[resultkey].numFailures = request[resultkey].numFailures + 1>
						<cfset numTestFailures = numTestFailures + 1>

					<cfelse>

						<!---
							another exception thrown
						--->
						<cfset status = "Error">
            <cfif ArrayLen(cfcatch.tagContext)>
            	<cfset template = "#ListLast(cfcatch.tagContext[1].template, "/")# line #cfcatch.tagContext[1].line#">
                <cfsavecontent variable="tagContext">
                	<ul>
                		<cfloop from="1" to="#ArrayLen(cfcatch.tagContext)#" index="i">
                			<li>#cfcatch.tagContext[i].template# line #cfcatch.tagContext[i].line#</li>
                		</cfloop>
                	</ul>
                </cfsavecontent>
                <cfset tagContext = Replace(tagContext, Chr(10), "", "all")>
            <cfelse>
            	<cfset template = "">
                <cfset tagContext = "[Unknown tagContext]">
            </cfif>

	          <cfif Len(template)>
							<cfset message = message & newline & template>
						</cfif>
            <cfif StructKeyExists(cfcatch, "sql") and Len(cfcatch.sql)>
            	<cfset message = message & newline & newline & cfcatch.sql>
            </cfif>
            <cfif Len(cfcatch.extendedInfo)>
							<cfset message = message & newline & newLine & cfcatch.extendedInfo>
						</cfif>
            <cfset message = message & newline & newline & tagContext>
            <cfif Len(cfcatch.detail)>
            	<cfset message = message & newline & newline & cfcatch.detail>
            </cfif>
						<cfset request[resultkey].ok = false>
						<cfset request[resultkey].numErrors = request[resultkey].numErrors + 1>
						<cfset numTestErrors = numTestErrors + 1>

					</cfif>

				</cfcatch>
				</cftry>

				<cfif structKeyExists(this, "teardown")>
					<cfset teardown()>
				</cfif>

				<cfset time = getTickCount() - time>

				<!---
					Record test results
				--->
				<cfset result = structNew()>
				<cfset result.testCase = testCase>
				<cfset result.testName = key>
				<cfset result.time = time>
				<cfset result.status = status>
				<cfset result.message = message>
				<cfset arrayAppend(request[resultkey].results, result)>

				<cfset request[resultkey].numTests = request[resultkey].numTests + 1>
				<cfset numTests = numTests + 1>

			</cfif>

		</cfloop>

		<cfset result = structNew()>
		<cfset result.testCase = testCase>
		<cfset result.numTests = numTests>
		<cfset result.numFailures = numTestFailures>
		<cfset result.numErrors = numTestErrors>
		<cfset arrayAppend(request[resultkey].summary, result)>

		<cfset request[resultkey].numCases = request[resultkey].numCases + 1>
		<cfset request[resultkey]["end"] = now()>

		<cfreturn numTestErrors eq 0>

	</cffunction>

	<!---
		Clear results.

		@param resultKey	Key to store distinct test result sets under in
							request scope, defaults to "test"
	--->
	<cffunction name="$resetTestResults" returntype="void" output="false">
		<cfargument name="resultKey" type="string" required="false" default="test">
		<cfscript>
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
		</cfscript>
	</cffunction>

	<!---
		Report test results at overall, test case and test level, highlighting
		failures and errors.

		@param resultKey	Key to retrive distinct test result sets from in
							request scope, defaults to "test"
		@returns			HTML formatted test results
	--->
	<cffunction name="$results" returntype="any" output="false">
		<cfargument name="resultKey" type="string" required="false" default="test">
		<cfset var loc = {}>
		<cfset loc.ret = false>
		<cfif structkeyexists(request, resultkey)>
			<cfset request[resultkey].path = TESTING_FRAMEWORK_VARS.WHEELS_TESTS_BASE_COMPONENT_PATH>
			<cfset loc.a = ArrayLen(request[resultkey].summary)>
			<cfset loc.b = ArrayLen(request[resultkey].results)>
			<cfloop from="1" to="#loc.a#" index="loc.i">
				<cfset request[resultkey].summary[loc.i].cleanTestCase = $cleanTestCase(request[resultkey].summary[loc.i].testCase)>
				<cfset request[resultkey].summary[loc.i].packageName = $cleanTestPath(request[resultkey].summary[loc.i].testCase)>
			</cfloop>
			<cfloop from="1" to="#loc.b#" index="loc.i">
				<cfset request[resultkey].results[loc.i].cleanTestCase = $cleanTestCase(request[resultkey].results[loc.i].testCase)>
				<cfset request[resultkey].results[loc.i].cleanTestName = $cleanTestName(request[resultkey].results[loc.i].testName)>
				<cfset request[resultkey].results[loc.i].packageName = $cleanTestPath(request[resultkey].results[loc.i].testCase)>
			</cfloop>
			<cfset loc.ret = request[resultkey]>
		</cfif>
		<cfreturn loc.ret>
	</cffunction>

  <cfscript>
  /*
   * Wheels Helper Methods
   */

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
      loc.instance.$runTest(loc.resultKey, loc.test)
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
  </cfscript>

</cfcomponent>
