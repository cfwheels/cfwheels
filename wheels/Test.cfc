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

<cfcomponent>

	<cfset variables.WHEELS_TESTS_BASE_COMPONENT_PATH = "">
	<cfset global = {}>
	
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

	<cffunction name="halt" returntype="Any" output="false" hint="used to dump an expression and halt testing. Useful when you want to see what an expression will output first so you can write tests for it.">
		<cfargument name="halt" type="boolean" required="true" hint="should we halt. true will halt and dump output. false will just return so tests can continue">
		<cfargument name="expression" type="string" required="true" hint="the expression you want to see output for">

		<cfif not arguments.halt>
			<cfreturn>
		</cfif>

		<cfdump var="#evaluate(arguments.expression)#"><cfabort>
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

	<cffunction name="loadModels" hint="allows you to load all or specific models into the test case">
		<cfargument name="models" type="string" required="false" default="" hint="a comma delimited list of the model you want to load. leave blank to load all models.">
		<cfset var loc = {}>
		
		<cfif not structkeyexists(variables, "model")>
			<cfinclude template="/wheelsMapping/global/functions.cfm">
		</cfif>
		
		<cfif !len(arguments.models)>
			<cfdirectory action="list" directory="#expandpath(application.wheels.modelPath)#" name="loc.models" filter="*.cfc" type="file">
			<cfset arguments.models = valuelist(loc.models.name)>
		</cfif>
		
		<cfloop list="#arguments.models#" index="loc.model">
			<cfset global[singularize(listfirst(loc.model, "."))] = model(listfirst(loc.model, "."))>
		</cfloop>
	</cffunction>

	<!---
		Instanciate all components in specified package and call their $runTest()
		method.

		@param testPackage	Package containing test components
		@param resultKey	Key to store distinct test result sets under in
							request scope, defaults to "test"
		@returns			true if no failures or errors detected.
	--->
	<cffunction name="$runTestPackage" returntype="boolean" output="true">
		<cfargument name="testPackage" type="string" required="true">
		<cfargument name="resultKey" type="string" required="false" default="test">

		<cfset var packageDir = "">
		<cfset var qPackage = "">
		<cfset var instance = "">
		<cfset var result = 0>
		<cfset var metadata = "">

		<!--
			Called with a testPackage argument.  List package directory contents, instanciate
			any components we find and call their run() method.
		--->
		<cfset packageDir = "/" & replace(testpackage, ".", "/", "ALL")>
		<cfdirectory action="list" directory="#expandPath(packageDir)#" name="qPackage" filter="*.cfc">
		<cfloop query="qPackage">
			<cfset instance = testPackage & "." & listFirst(qPackage.name, ".")>
			<cfif $isValidTest(instance)>
				<cfset instance = createObject("component", instance)>
				<cfset result = result + instance.$runTest(resultKey)>
			</cfif>
		</cfloop>

		<cfreturn result eq 0>

	</cffunction>

	<!---
		Run all the tests in a component.

		@param resultKey	Key to store distinct test result sets under in
							request scope, defaults to "test"
		@returns true if no errors
	--->
	<cffunction name="$runTest" returntype="boolean" output="true">
		<cfargument name="resultKey" type="string" required="false" default="test">

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
		<cfparam name="request.#resultkey#" 				default="#structNew()#">
		<cfparam name="request.#resultkey#.begin" 			default="#now()#">
		<cfparam name="request.#resultkey#.ok" 				default="true">
		<cfparam name="request.#resultkey#.numCases" 		default="0">
		<cfparam name="request.#resultkey#.numTests" 		default="0">
		<cfparam name="request.#resultkey#.numSuccesses" 	default="0">
		<cfparam name="request.#resultkey#.numFailures" 	default="0">
		<cfparam name="request.#resultkey#.numErrors" 		default="0">
		<cfparam name="request.#resultkey#.summary"			default="#arrayNew(1)#">
		<cfparam name="request.#resultkey#.results" 		default="#arrayNew(1)#">

		<cfset testCase = getMetadata(this).name>

		<!---
			Iterate through the members of the this scope in alphabetical order,
			invoking methods starting in "test".  Wrap with calls to setup()
			and teardown() if provided.
		--->
		<cfset keyList = listSort(structKeyList(this), "textnocase", "asc")>

		<cfif structKeyExists(this, "_setup")>
			<cfset _setup()>
		</cfif>

		<cfloop list="#keyList#" index="key">

			<cfif left(key, 4) eq "test" and isCustomFunction(this[key])>

				<cftry>
				
					<cfset time = getTickCount()>

					<cfset loc = duplicate(global)>

					<cfif structKeyExists(this, "setup")>
						<cfset setup()>
					</cfif>

					<cfset message = "">
					<cfinvoke method="#key#">
					<cfset status = "Success">
					<cfset request[resultkey].numSuccesses = request[resultkey].numSuccesses + 1>

					<cfif structKeyExists(this, "teardown")>
						<cfset teardown()>
					</cfif>

					<cfset time = getTickCount() - time>

				<cfcatch type="any">

					<cfset time = getTickCount() - time>
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
						<cfset message = message & newline & listLast(cfcatch.tagContext[1].template, "/") & " line " & cfcatch.tagContext[1].line  & newline & newline & cfcatch.detail>
						<cfset request[resultkey].ok = false>
						<cfset request[resultkey].numErrors = request[resultkey].numErrors + 1>
						<cfset numTestErrors = numTestErrors + 1>

					</cfif>

				</cfcatch>
				</cftry>

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

		<cfif structKeyExists(this, "_teardown")>
			<cfset _teardown()>
		</cfif>

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

		<cfset request[resultkey] = structNew()>
		<cfparam name="request[resultkey].begin" 			default="#now()#">
		<cfparam name="request[resultkey].ok" 				default="true">
		<cfparam name="request[resultkey].numCases" 		default="0">
		<cfparam name="request[resultkey].numTests" 		default="0">
		<cfparam name="request[resultkey].numSuccesses" 	default="0">
		<cfparam name="request[resultkey].numFailures" 		default="0">
		<cfparam name="request[resultkey].numErrors" 		default="0">
		<cfparam name="request[resultkey].summary"			default="#arrayNew(1)#">
		<cfparam name="request[resultkey].results" 			default="#arrayNew(1)#">

	</cffunction>

	<!---
		Report test results at overall, test case and test level, highlighting
		failures and errors.

		@param resultKey	Key to retrive distinct test result sets from in
							request scope, defaults to "test"
		@returns			HTML formatted test results
	--->
	<cffunction name="$HTMLFormatTestResults" returntype="string" output="false">
		<cfargument name="resultKey" type="string" required="false" default="test">

		<cfset var testIndex = "">
		<cfset var newline = chr(10) & chr(13)>

		<cfif not structkeyexists(request, resultkey)>

			<cfsavecontent variable="result">
			<cfoutput>
			<p>No tests found.</p>
			</cfoutput>
			</cfsavecontent>

		<cfelse>

			<cfsavecontent variable="result">
			<cfoutput>
			<style type="text/css">
			.failed {color:red;font-weight:bold}
			.success {color:green;font-weight:bold}
			table.testing {border:0; margin-bottom:15px;}
			table.testing td, table.testing th {padding:2px 20px 2px 2px;text-align:left;vertical-align:top;font-size:14px;}
			table.testing td.numeric {text-align:right;}
			</style>
			<table class="testing">
				<tr><th class="<cfif request[resultkey].ok>success<cfelse>failed</cfif>">Status</th><td class="numeric<cfif request[resultkey].ok> success<cfelse> failed</cfif>"><cfif request[resultkey].ok>Passed<cfelse>Failed</cfif></td></tr>
				<tr><th>Path</th><td class="numeric">#variables.WHEELS_TESTS_BASE_COMPONENT_PATH#</td></tr>
				<tr><th>Date</th><td class="numeric">#dateFormat(request[resultkey].end)#</td></tr>
				<tr><th>Begin</th><td class="numeric">#timeFormat(request[resultkey].begin, "HH:mm:ss L")#</td></tr>
				<tr><th>End</th><td class="numeric">#timeFormat(request[resultkey].end, "HH:mm:ss L")#</td></tr>
				<tr><th>Duration</th><td class="numeric">#timeFormat(request[resultkey].end - request[resultkey].begin, "HH:mm:ss")#</td></tr>
				<tr><th>Cases</th><td class="numeric">#request[resultkey].numCases#</td></tr>
				<tr><th>Tests</th><td class="numeric">#request[resultkey].numTests#</td></tr>
				<tr><th<cfif request[resultkey].numFailures neq 0> class="failed"</cfif>>Failures</th><td class="numeric<cfif request[resultkey].numFailures neq 0> failed</cfif>">#request[resultkey].numFailures#</td></tr>
				<tr><th<cfif request[resultkey].numErrors neq 0> class="failed"</cfif>>Errors</th><td class="numeric<cfif request[resultkey].numErrors neq 0> failed</cfif>">#request[resultkey].numErrors#</td></tr>
			</table>
			<table class="testing">
			<tr><th>Test Case</th></th><th>Tests</th><th>Failures</th><th>Errors</th></tr>
			<cfloop from="1" to="#arrayLen(request[resultkey].summary)#" index="testIndex">
				<tr>
					<td>#$cleanUpHTMLTestCaseName(request[resultkey].summary[testIndex].testCase)#</td>
					<td class="numeric">#request[resultkey].summary[testIndex].numTests#</td>
					<td class="numeric<cfif request[resultkey].summary[testIndex].numFailures neq 0> failed</cfif>">#request[resultkey].summary[testIndex].numFailures#</td>
					<td class="numeric <cfif request[resultkey].summary[testIndex].numErrors neq 0> failed</cfif>">#request[resultkey].summary[testIndex].numErrors#</td>
				</tr>
			</cfloop>
			</table>
			<table class="testing">
			<tr><th>Test Case</th><th>Test Name</th><th>Time</th><th>Status</th></tr>
			<cfloop from="1" to="#arrayLen(request[resultkey].results)#" index="testIndex">
				<tr>
					<td>#$cleanUpHTMLTestCaseName(request[resultkey].results[testIndex].testCase)#</td>
					<td>#$cleanUpHTMLTestName(request[resultkey].results[testIndex].testName)#</td>
					<td class="numeric">#request[resultkey].results[testIndex].time#</td>
					<td class="<cfif request[resultkey].results[testIndex].status eq 'Success'>success<cfelse>failed</cfif>">#request[resultkey].results[testIndex].status#</td>
				</tr>
				<cfif request[resultkey].results[testIndex].status neq "Success">
					<tr><td colspan="7" class="failed">#replace(request[resultkey].results[testIndex].message, newline, "<br>", "ALL")#</td></tr>
				</cfif>
			</cfloop>
			</table>
			</cfoutput>
			</cfsavecontent>

		</cfif>

		<cfreturn REReplace(result, "[	 " & newline & "]{2,}", " ", "ALL")>

	</cffunction>

	<!--- WheelsRunner --->
	<cffunction name="$WheelsRunner" returntype="string" output="false">
		<cfargument name="options" type="struct" required="false" default="#structnew()#">
		<cfset var loc = {}>
		<cfset var q = "">

		<!--- the key in the request scope that will contain the test results --->
		<cfset loc.resultKey = "WheelsTests">

		<!--- save the original environment for overloaded --->
		<cfset loc.savedenv = duplicate(application)>

		<!--- by default we run all tests, however they can specify to run a specific oset of tests --->
		<cfset loc.package = "">

		<!--- default test type --->
		<cfset loc.type = "core">

		<!--- if they specified a package we should only run that --->
		<cfif structkeyexists(arguments.options, "package")>
			<cfset loc.package = arguments.options.package>
		</cfif>

		<!--- overwrite the default test type if passed --->
		<cfif structkeyexists(arguments.options, "type")>
			<cfset loc.type = arguments.options.type>
		</cfif>

		<!--- which tests to run --->
		<cfif loc.type eq "core">
			<!--- core tests --->
			<cfset loc.root_test_path = application.wheels.wheelsComponentPath>
		<cfelseif loc.type eq "app">
			<!--- app tests --->
			<cfset loc.root_test_path = application.wheels.rootComponentPath>
		<cfelse>
			<!--- specific plugin tests --->
			<cfset loc.root_test_path = "#application.wheels.rootComponentPath#.#application.wheels.pluginComponentPath#.#loc.type#">
		</cfif>

		<cfset loc.root_test_path = loc.root_test_path & ".tests">

		<!--- add the package if specified --->
		<cfset loc.test_path = listappend("#loc.root_test_path#", loc.package, ".")>

		<!--- clean up testpath --->
		<cfset loc.test_path = listchangedelims(loc.test_path, ".", "./\")>

		<!--- convert to regular path --->
		<cfset loc.relative_root_test_path = "/" & listchangedelims(loc.root_test_path, "/", ".")>
		<cfset loc.full_root_test_path = expandpath(loc.relative_root_test_path)>
		<cfset loc.releative_test_path = "/" & listchangedelims(loc.test_path, "/", ".")>
		<cfset loc.full_test_path = expandPath(loc.releative_test_path)>

		<!---
		if env.cfm files exists, call to override enviroment settings so tests can run.
		when overriding, save the original env so we can put it back later.
		 --->
		<cfif FileExists(loc.full_root_test_path & "/env.cfm")>
			<cfinclude template="#loc.relative_root_test_path & '/env.cfm'#">
		</cfif>

		<!--- populate the test database only on reload --->
		<cfif structkeyexists(arguments.options, "reload") && arguments.options.reload eq true && FileExists(loc.full_root_test_path & "/populate.cfm")>
			<cfinclude template="#loc.relative_root_test_path & '/populate.cfm'#">
		</cfif>

		<!--- for test results display --->
		<cfset variables.WHEELS_TESTS_BASE_COMPONENT_PATH = loc.test_path>

		<cfdirectory directory="#loc.full_test_path#" action="list" recurse="true" name="q" filter="*.cfc" />

		<!--- run tests --->
		<cfloop query="q">
			<cfset loc.testname = listchangedelims(removechars(directory, 1, len(loc.full_test_path)), ".", "\/")>
			<!--- directories that begin with an underscore are ignored --->
			<cfif not refindnocase("(^|\.)_", loc.testname)>
				<cfset loc.testname = listprepend(loc.testname, loc.test_path, ".")>
				<cfset loc.testname = listappend(loc.testname, listfirst(name, "."), ".")>
				<!--- ignore invalid tests and test that begin with underscores --->
				<cfif left(name, 1) neq "_" and $isValidTest(loc.testname)>
					<cfset loc.instance = createObject("component", loc.testname)>
					<cfset loc.instance.$runTest(loc.resultKey)>
				</cfif>
			</cfif>
		</cfloop>

		<!--- swap back the enviroment --->
		<cfset application = loc.savedenv>

		<cfreturn $HTMLFormatTestResults(loc.resultKey)>

	</cffunction>

	<cffunction name="$isValidTest" returntype="boolean" output="false">
		<cfargument name="component" type="string" required="true" hint="path to the component you want to check as a valid test">
		<cfargument name="shouldExtend" type="string" required="false" default="Test" hint="if the component should extend a base component to be a valid test">
		<cfset var loc = {}>
		<cfif len(arguments.shouldExtend)>
			<cfset loc.metadata = GetComponentMetaData(arguments.component)>
			<cfif not structkeyexists(loc.metadata, "extends") or loc.metadata.extends.fullname does not contain arguments.shouldExtend>
				<cfreturn false>
			</cfif>
		</cfif>
		<cfreturn true>
	</cffunction>

	<cffunction name="$cleanUpHTMLTestCaseName" returntype="string" output="false" hint="removes the base test directory from the test name to make them prettier and more readable">
		<cfargument name="str" type="string" required="true" hint="test case name to clean up">
		<cfreturn listchangedelims(replace(arguments.str, variables.WHEELS_TESTS_BASE_COMPONENT_PATH, ""), ".", ".")>
	</cffunction>

	<cffunction name="$cleanUpHTMLTestName" returntype="string" output="false" hint="cleans up the test name so they are more readable">
		<cfargument name="str" type="string" required="true" hint="test name to clean up">
		<cfreturn trim(rereplacenocase(removechars(arguments.str, 1, 4), "_|-", " ", "all"))>
	</cffunction>

	<cfinclude template="plugins/injection.cfm">
</cfcomponent>