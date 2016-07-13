<!--- variables that are used by the testing framework itself --->
<cfset TESTING_FRAMEWORK_VARS = {}>
<cfset TESTING_FRAMEWORK_VARS.WHEELS_TESTS_BASE_COMPONENT_PATH  = "">
<cfset TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH = "">
<cfset TESTING_FRAMEWORK_VARS.RUNNING_TEST = "">

<!--- include main wheels functions in tests by default --->
<cfinclude template="../global/functions.cfm">
<cfinclude template="../plugins/injection.cfm">

<!--- WheelsRunner --->
<cffunction name="$WheelsRunner" returntype="any" output="false">
  <cfargument name="options" type="struct" required="false" default="#structnew()#">
  <cfset var loc = {}>
  <cfset var q = "">

  <!--- the key in the request scope that will contain the test results --->
  <cfset loc.resultKey = "WheelsTests">

  <!--- save the original environment for overloaded --->
  <cfset loc.savedenv = duplicate(application)>

  <!--- not only can we specify the package, but also the test we want to run --->
  <cfset loc.test = "">
  <cfif structkeyexists(arguments.options, "test") and len(arguments.options.test)>
    <cfset loc.test = arguments.options.test>
  </cfif>

  <!--- resolve paths --->
  <cfset loc.paths = $resolvePaths(arguments.options)>

  <!--- tests to run --->
  <cfset q = $listTestPackages(arguments.options, loc.paths.test_filter)>

  <!--- run tests --->
  <cfloop query="q">
    <cfset loc.instance = createObject("component", package)>
    <cfset loc.instance.$runTest(loc.resultKey, loc.test)>
  </cfloop>

  <!--- swap back the enviroment --->
  <cfset structappend(application, loc.savedenv, true)>

  <!--- return the results --->
  <cfreturn $results(loc.resultKey)>

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

<cffunction name="$cleanTestCase" returntype="string" output="false" hint="removes the base test directory from the test name to make them prettier and more readable">
  <cfargument name="str" type="string" required="true" hint="test case name to clean up">
  <cfreturn listchangedelims(replace(arguments.str, TESTING_FRAMEWORK_VARS.WHEELS_TESTS_BASE_COMPONENT_PATH, ""), ".", ".")>
</cffunction>

<cffunction name="$cleanTestName" returntype="string" output="false" hint="cleans up the test name so they are more readable">
  <cfargument name="str" type="string" required="true" hint="test name to clean up">
  <cfreturn humanize(Trim(REReplaceNoCase(RemoveChars(arguments.str, 1, 4), "_|-", " ", "all")))>
</cffunction>

<cffunction name="$cleanTestPath" returntype="string" output="false" hint="cleans up the test name so they are more readable">
  <cfargument name="str" type="string" required="true" hint="test name to clean up">
  <cfreturn listchangedelims(replace(arguments.str, TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH, ""), ".", ".")>
</cffunction>

<cffunction name="$resolvePaths" returntype="struct" output="false" hint="this resolves all the paths needed to run the tests">
  <cfargument name="options" type="struct" required="false" default="#structnew()#">
  <cfset var loc = {}>

  <!--- container for returning the paths --->
  <cfset loc.paths = {}>

  <!--- default test type --->
  <cfset loc.type = "core">

  <!--- testfilter --->
  <cfset loc.paths.test_filter = "*">

  <!--- by default we run all packages, however they can specify to run a specific package of tests --->
  <cfset loc.package = "">

  <!--- if they specified a package we should only run that --->
  <cfif structkeyexists(arguments.options, "package") and len(arguments.options.package)>
    <cfset loc.package = arguments.options.package>
  </cfif>

  <!--- overwrite the default test type if passed --->
  <cfif structkeyexists(arguments.options, "type") and len(arguments.options.type)>
    <cfset loc.type = arguments.options.type>
  </cfif>

  <!--- which tests to run --->
  <cfif loc.type eq "core">
    <!--- core tests --->
    <cfset TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH = application.wheels.wheelsComponentPath>
  <cfelseif loc.type eq "app">
    <!--- app tests --->
    <cfset TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH = application.wheels.rootComponentPath>
  <cfelse>
    <!--- specific plugin tests --->
    <cfset TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH = application.wheels.rootComponentPath>
    <cfset TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH = ListAppend(TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH, "#application.wheels.pluginComponentPath#.#loc.type#", ".")>
  </cfif>

  <cfset TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH = ListAppend(TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH, "tests", ".")>

  <!--- add the package if specified --->
  <cfset loc.paths.test_path = listappend("#TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH#", loc.package, ".")>

  <!--- clean up testpath --->
  <cfset loc.paths.test_path = listchangedelims(loc.paths.test_path, ".", "./\")>

  <!--- convert to regular path --->
  <cfset loc.paths.relative_root_test_path = "/" & listchangedelims(TESTING_FRAMEWORK_VARS.ROOT_TEST_PATH, "/", ".")>
  <cfset loc.paths.full_root_test_path = expandpath(loc.paths.relative_root_test_path)>
  <cfset loc.paths.releative_test_path = "/" & listchangedelims(loc.paths.test_path, "/", ".")>
  <cfset loc.paths.full_test_path = expandPath(loc.paths.releative_test_path)>

  <cfif not DirectoryExists(loc.paths.full_test_path)>
    <cfif FileExists(loc.paths.full_test_path & ".cfc")>
      <cfset loc.paths.test_filter = reverse(listfirst(reverse(loc.paths.test_path), "."))>
      <cfset loc.paths.test_path = reverse(listrest(reverse(loc.paths.test_path), "."))>
      <cfset loc.paths.releative_test_path = "/" & listchangedelims(loc.paths.test_path, "/", ".")>
      <cfset loc.paths.full_test_path = expandPath(loc.paths.releative_test_path)>
    <cfelse>
      <cfthrow
        type="Wheels.Testing"
        message="Cannot find test package or single test"
        detail="In order to run test you must supply a valid test package or single test file to run">
    </cfif>
  </cfif>

  <!--- for test results display --->
  <cfset TESTING_FRAMEWORK_VARS.WHEELS_TESTS_BASE_COMPONENT_PATH = loc.paths.test_path>

  <cfreturn loc.paths>
</cffunction>

<cffunction name="$listTestPackages" returntype="query" output="false" hint="returns a query containing all the test to run and their directory path">
  <cfargument name="options" type="struct" required="false" default="#structnew()#">
  <cfargument name="filefilter" type="string" required="false" default="*">
  <cfset var loc = {}>
  <cfset var q = "">
  <cfset var t = QueryNew("package","Varchar")>

  <cfset loc.paths = $resolvePaths(arguments.options)>

  <cfset $loadTestEnvAndPopuplateDatabase(loc.paths, arguments.options)>

  <cfdirectory directory="#loc.paths.full_test_path#" action="list" recurse="true" name="q" filter="#arguments.filefilter#.cfc" />

  <!--- run tests --->
  <cfloop query="q">
    <cfset loc.testname = listchangedelims(removechars(directory, 1, len(loc.paths.full_test_path)), ".", "\/")>
    <!--- directories that begin with an underscore are ignored --->
    <cfif not refindnocase("(^|\.)_", loc.testname)>
      <cfset loc.testname = listprepend(loc.testname, loc.paths.test_path, ".")>
      <cfset loc.testname = listappend(loc.testname, listfirst(name, "."), ".")>
      <!--- ignore invalid tests and test that begin with underscores --->
      <cfif left(name, 1) neq "_" and $isValidTest(loc.testname)>
        <cfset QueryAddRow(t)>
        <cfset QuerySetCell(t, "package", loc.testname)>
      </cfif>
    </cfif>
  </cfloop>

  <cfreturn t>
</cffunction>

<cffunction name="$loadTestEnvAndPopuplateDatabase">
  <cfargument name="paths" type="struct" required="true">
  <cfargument name="options" type="struct" required="true">

  <cfif FileExists(arguments.paths.full_root_test_path & "/env.cfm")>
    <cfinclude template="#arguments.paths.relative_root_test_path & '/env.cfm'#">
  </cfif>

  <!--- populate the test database only on reload --->
  <cfif structkeyexists(arguments.options, "reload") && arguments.options.reload eq true && FileExists(arguments.paths.full_root_test_path & "/populate.cfm")>
    <cfinclude template="#arguments.paths.relative_root_test_path & '/populate.cfm'#">
  </cfif>

</cffunction>
