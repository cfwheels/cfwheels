<cfcomponent extends="wheelsMapping.Test">

	<cfset cache = CreateObject("component", "wheels.Cache").init()>

	<cffunction name="setup">
		<cfset StructDelete(variables, "result")>
		<cfset StructDelete(variables, "results")>
	</cffunction>

	<cffunction name="testOneValue">
		<cfset cache.add(key="1", value="a")>
		<cfset result = cache.get(key="1")>
		<cfset assert("NOT IsBoolean(result) AND result IS 'a'")>
	</cffunction>

</cfcomponent>