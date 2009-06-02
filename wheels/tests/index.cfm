<!---

Test Runner for wheels

Get all the underline directories (packages). Each package should contain
a "tests" directory where the tests will live.

Ex. /wheels/tests/model/tests

Each package corresponds to a certain aspect of wheels, such as the
"model" package should contain all the tests for the model component
and so on (you get this).

Place any components or includes within the base package. In other words
if all the test in the "model" package need a init_model.cfc. it should be
placed in the base model package (/wheels/tests/model). Any test can then
access the file if need be.

To run the tests

 --->

<!--- current directory --->
<cfset thisdir = expandpath('.')>
<cfdirectory directory="#thisdir#" action="list" recurse="true" name="packages"/>

<!--- remove any files from this directory --->
<cfquery name="packages" dbtype="query">
select *
from packages
where
	name <> '#thisdir#'
	and type = 'Dir'
</cfquery>

<!--- run tests --->
<cfset test = createObject("component", "base")>
<cfloop query="packages">
	<cfset test.runTestPackage("wheels.tests.#name#.tests")>
</cfloop>

<!--- output the results --->
<cfoutput>#test.HTMLFormatTestResults()#</cfoutput>