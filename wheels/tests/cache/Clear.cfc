<cfcomponent extends="wheelsMapping.Test">

	<cfset cache = CreateObject("component", "wheels.Cache").init()>

	<cffunction name="setup">
		<cfset StructDelete(variables, "result")>
		<cfset StructDelete(variables, "results")>
	</cffunction>

	<cffunction name="testAll">
		<cfset cache.add(key="1", value="a")>
		<cfset cache.clear()>
		<cfset result = cache.count()>
		<cfset assert("result IS 0")>
	</cffunction>

	<cffunction name="testNameSpace">
		<cfset cache.add(key="1", value="a")>
		<cfset cache.add(key="2", value="b", category="pages")>
		<cfset cache.clear(category="pages")>
		<cfset results.one = cache.count()>
		<cfset results.two = cache.count(category="pages")>
		<cfset assert("results.one IS 1 AND results.two IS 0")>
	</cffunction>

</cfcomponent>