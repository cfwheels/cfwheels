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

</cfcomponent>