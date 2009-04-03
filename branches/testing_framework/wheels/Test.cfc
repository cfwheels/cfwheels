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

	<!---
		Instanciate all components in specified package and call their runTest()
		method.

		@param testPackage	Package containing test components
		@param resultKey	Key to store distinct test result sets under in
							request scope, defaults to "test"
		@returns			true if no failures or errors detected.
	--->
	<cffunction returntype="boolean" name="runTestPackage" output="true">
		<cfargument name="testPackage" type="string" required="true">
		<cfargument name="resultKey" type="string" required="false" default="test">

		<cfset var packageDir = "">
		<cfset var qPackage = "">
		<cfset var instance = "">
		<cfset var result = 0>

		<!--
			Called with a testPackage argument.  List package directory contents, instanciate
			any components we find and call their run() method.
		--->
		<cfset packageDir = "/" & replace(testpackage, ".", "/", "ALL")>
		
		<cfdirectory action="list"  directory="#expandPath(packageDir)#" name="qPackage">

		<cfloop query="qPackage">
			<cfif listLast(qPackage.name, ".") eq "cfc">
				<cfdump var="#testPackage & "." & listFirst(qPackage.name, '.')#">
 				<cfset instance = createObject("component", testPackage & "." & listFirst(qPackage.name, "."))>
				<cfset result = result + instance.runTest(resultKey)>
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
	<cffunction returntype="boolean" name="runTest" output="true">
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
		<cfparam name="request.#resultkey#" 				default=#structNew()#>
		<cfparam name="request.#resultkey#.begin" 			default=#now()#>
		<cfparam name="request.#resultkey#.ok" 				default=true>
		<cfparam name="request.#resultkey#.numCases" 		default=0>
		<cfparam name="request.#resultkey#.numTests" 		default=0>
		<cfparam name="request.#resultkey#.numSuccesses" 	default=0>
		<cfparam name="request.#resultkey#.numFailures" 	default=0>
		<cfparam name="request.#resultkey#.numErrors" 		default=0>
		<cfparam name="request.#resultkey#.summary"			default=#arrayNew(1)#>
		<cfparam name="request.#resultkey#.results" 		default=#arrayNew(1)#>

		<cfset testCase = getMetadata(this).name>

		<!---
			Iterate through the members of the this scope in alphabetical order,
			invoking methods starting in "test".  Wrap with calls to setup()
			and teardown() if provided.
		--->
		<cfset keyList = listSort(structKeyList(this), "textnocase", "asc")>

		<cfloop list=#keyList# index="key">

			<cfif left(key, 4) eq "test" and isCustomFunction(this[key])>

				<cftry>

					<cfset time = getTickCount()>

					<cfif structKeyExists(this, "setup")>
						<cfset setup()>
					</cfif>

					<cfset message = "">
					<cfinvoke method=#key#>
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
		Called from a test function to cause the test to fail.

		@param message	Message to record in test results against failure.
	--->
	<cffunction returntype="void" name="fail">
		<cfargument type="string" name="message" required=true>

		<!---
			run() interprets exception with this errorcode as a "Failure".
			All other errorcodes cause are interpreted as an "Error".
		--->
		<cfthrow errorcode="__FAIL__" message=#message#>

	</cffunction>




	<!---
		Called from a test function.  If expression evaluates to false,
		record a failure against the test.

		@param	expression	String containing CFML expression to evaluate
		@param	2..n		Optional. String(s) containing space-delimited list
							of variables to evaluate and include in the
							failure message to help determine cause of failed
							assertion.
	--->
	<cffunction returntype="void" name="assert" output="false">
		<cfargument type="string" name="expression" required=true>

		<cfset var token = "">
		<cfset var tokenValue = "">
		<cfset var message = "assert failed: #expression#">
		<cfset var newline = chr(10) & chr(13)>
		<cfset var i = "">
		<cfset var evaluatedTokens = "">

		<cfif not evaluate(expression)>

			<cfloop from=1 to=#arrayLen(arguments)# index="i">

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
		Clear results.

		@param resultKey	Key to store distinct test result sets under in
							request scope, defaults to "test"
	--->
	<cffunction returntype="void" name="resetTestResults" output="false">
		<cfargument name="resultKey" type="string" required="false" default="test">

		<cfset request[resultkey] = structNew()>
		<cfparam name="request[resultkey].begin" 		default=#now()#>
		<cfparam name="request[resultkey].ok" 			default=true>
		<cfparam name="request[resultkey].numCases" 		default=0>
		<cfparam name="request[resultkey].numTests" 		default=0>
		<cfparam name="request[resultkey].numSuccesses" 	default=0>
		<cfparam name="request[resultkey].numFailures" 	default=0>
		<cfparam name="request[resultkey].numErrors" 	default=0>
		<cfparam name="request[resultkey].summary"		default=#arrayNew(1)#>
		<cfparam name="request[resultkey].results" 		default=#arrayNew(1)#>

	</cffunction>




	<!---
		Report test results at overall, test case and test level, highlighting
		failures and errors.

		@param resultKey	Key to retrive distinct test result sets from in
							request scope, defaults to "test"
		@returns			HTML formatted test results
	--->
	<cffunction returntype="string" name="HTMLFormatTestResults" output="false">
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
			<table cellpadding="5" cellspacing="5">
				<cfif not request[resultkey].ok>
					<tr><th align="left"><span style="color:red;font-weight:bold">Status</span></th><td><span style="color:red;font-weight:bold">Failed</span></td></tr>
				<cfelse>
					<tr><th align="left">Status</th><td>Passed</td></tr>
				</cfif>
				<tr><th align="left">Date</th><td>#dateFormat(request[resultkey].end)#</td></tr>
				<tr><th align="left">Begin</th><td>#timeFormat(request[resultkey].begin, "HH:mm:ss L")#</td></tr>
				<tr><th align="left">End</th><td>#timeFormat(request[resultkey].end, "HH:mm:ss L")#</td></tr>
				<tr><th align="left">Cases</th><td align="right">#request[resultkey].numCases#</td></tr>
				<tr><th align="left">Tests</th><td align="right">#request[resultkey].numTests#</td></tr>
				<cfif request[resultkey].numFailures neq 0>
					<tr><th align="left"><span style="color:red;font-weight:bold">Failures</span></th>
					<td align="right"><span style="color:red;font-weight:bold">#request[resultkey].numFailures#</span></td></tr>
				<cfelse>
					<tr><th align="left">Failures</th><td align="right">#request[resultkey].numFailures#</td></tr>
				</cfif>
				<cfif request[resultkey].numErrors neq 0>
					<tr><th align="left"><span style="color:red;font-weight:bold">Errors</span></th>
					<td align="right"><span style="color:red;font-weight:bold">#request[resultkey].numErrors#</span></td></tr>
				<cfelse>
					<tr><th align="left">Errors</th><td align="right">#request[resultkey].numErrors#</td></tr>
				</cfif>
			</table>
			<br>
			<table border="0" cellpadding="5" cellspacing="5">
			<tr align="left"><th>Test Case</th><th>Tests</th><th>Failures</th><th>Errors</th></tr>
			<cfloop from="1" to=#arrayLen(request[resultkey].summary)# index="testIndex">
				<tr valign="top">
				<td>#request[resultkey].summary[testIndex].testCase#</td>
				<td align="right">#request[resultkey].summary[testIndex].numTests#</td>
				<cfif request[resultkey].summary[testIndex].numFailures neq 0>
					<td align="right"><span style="color:red;font-weight:bold">#request[resultkey].summary[testIndex].numFailures#</span></td>
				<cfelse>
					<td align="right">#request[resultkey].summary[testIndex].numFailures#</td>
				</cfif>
				<cfif request[resultkey].summary[testIndex].numErrors neq 0>
					<td align="right"><span style="color:red;font-weight:bold">#request[resultkey].summary[testIndex].numErrors#</span></td>
				<cfelse>
					<td align="right">#request[resultkey].summary[testIndex].numErrors#</td>
				</cfif>
				</tr>
			</cfloop>
			</table>
			<br>
			<table border="0" cellpadding="5" cellspacing="5">
			<tr align="left"><th>Test Case</th><th>Test Name</th><th>Time</th><th>Status</th><th>Message</th></tr>
			<cfloop from="1" to=#arrayLen(request[resultkey].results)# index="testIndex">
				<tr valign="top">
				<td>#request[resultkey].results[testIndex].testCase#</td>
				<td>#request[resultkey].results[testIndex].testName#</td>
				<td align="right">#request[resultkey].results[testIndex].time#</td>
				<cfif request[resultkey].results[testIndex].status neq "Success">
					<td><span style="color:red;font-weight:bold">#request[resultkey].results[testIndex].status#</span></td>
					<td><span style="color:red;font-weight:bold">#replace(request[resultkey].results[testIndex].message, newline, "<br>", "ALL")#</span></td>
				<cfelse>
					<td>#request[resultkey].results[testIndex].status#</td>
					<td>#request[resultkey].results[testIndex].message#</td>
				</cfif>
				</tr>
			</cfloop>
			</table>
			</cfoutput>
			</cfsavecontent>

		</cfif>

		<cfreturn REReplace(result, "[	 " & newline & "]{2,}", " ", "ALL")>

	</cffunction>
	
	
	
	
	<!--- WheelsRunner --->
	<cffunction name="WheelsRunner" access="public" output="false" returntype="string">
		<cfargument name="options" type="struct" required="false" default="#structnew()#">
		<cfset var loc = {}>
		<cfset var q = "">
		<cfset loc.s = {}>
		<cfset loc.s.testPackage = "">
		<cfset loc.s.resultKey = "WheelsTests">
		
		<cfset loc.packages = "">
		<cfset loc.type = "core">
		
		<cfif structkeyexists(arguments.options, "packages")>
			<cfset loc.packages = arguments.options.packages>
		</cfif>
		
		<cfif structkeyexists(arguments.options, "type")>
			<cfset loc.type = arguments.options.type>
		</cfif>
		
		<cfset loc.componentpath = listappend(application.wheels.rootcomponentPath, "#application.wheels.pluginComponentPath#.#loc.type#", ".")>

		<!--- core test --->
		<cfif loc.type eq "core">
			<cfset loc.componentpath = listappend(application.wheels.wheelsComponentPath, "tests", ".")>
		<cfelseif loc.type eq "app">
			<cfset loc.componentpath = listappend(application.wheels.rootcomponentPath, "tests", ".")>
		</cfif>
			
		<!--- clean up componentpath --->
		<cfset loc.componentpath = listchangedelims(loc.componentpath, ".", ".")>
		<!--- convert to regular path --->
		<cfset loc.path = expandPath("/" & listchangedelims(loc.componentpath, "/", "."))>

		<cfdirectory directory="#loc.path#" action="list" recurse="true" name="q" />

		<!--- remove any files from this directory --->
		<cfquery name="q" dbtype="query">
		select *
		from q
		where
			name <> '#loc.path#'
			and type = 'Dir'
			<cfif not listfindnocase("core,app", loc.type)>
			and name = 'tests'
			</cfif>
		</cfquery>

		<!--- run tests --->
		<cfloop query="q">
			<cfset loc.s.testPackage = "#loc.componentpath#.#name#">
			<cfset runTestPackage(argumentcollection=loc.s)>
		</cfloop>
		
		<cfreturn HTMLFormatTestResults(loc.s.resultKey)>
	
	</cffunction>

</cfcomponent>