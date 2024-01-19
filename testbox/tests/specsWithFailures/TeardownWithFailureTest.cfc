<cfcomponent extends="testbox.system.compat.framework.TestCase" >

	<!--- this will run before every single test in this test case --->
	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		<cfdump var="setup :#arguments.toString()#" output="console">
	</cffunction>

	<!--- this will run after every single test in this test case --->
	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">
		<cfdump var="tearDown :#arguments.toString()#" output="console">
	</cffunction>

	<!--- this will run once after initialization and before setUp() --->
	<cffunction name="beforeTests" returntype="void" access="public" hint="put things here that you want to run before all tests">
		<cfdump var="beforeTests" output="console">
	</cffunction>

	<!--- this will run once after all tests have been run --->
	<cffunction name="afterTests" returntype="void" access="public" hint="put things here that you want to run after all tests">
		<cfdump var="afterTests" output="console">
	</cffunction>

	<cffunction name="stonesFailTest" returntype="void" access="public">
		<!--- exercise your component under test --->
		<cfset var result = "Mick Jagger">

		<cfdump var="TEST: stonesFailTest (assertion will fail)" output="console">

		<!--- if you want to "see" your data -- including complex variables, you can pass them to debug() and they will be available to you either in the HTML output or in the Eclipse plugin via rightclick- "Open TestCase results in browser" --->
		<cfset debug(result)>

		<!--- make some assertion based on the result of exercising the component --->
		<cfset assertEquals("Keith Richards",result,"This is really NOT equal")>
	</cffunction>

	<cffunction name="stonesSuccessTest" returntype="void" access="public">
		<!--- exercise your component under test --->
		<cfset var result = "Mick Jagger">

		<cfdump var="TEST: stonesSuccessTest (assertion true)" output="console">

		<!--- if you want to "see" your data -- including complex variables, you can pass them to debug() and they will be available to you either in the HTML output or in the Eclipse plugin via rightclick- "Open TestCase results in browser" --->
		<cfset debug(result)>

		<!--- make some assertion based on the result of exercising the component --->
		<cfset assertEquals("Mick Jagger",result,"This is really equal")>

	</cffunction>

</cfcomponent>