<cfcomponent extends="wheelsMapping.Test">

	<cfset pkg.cache = CreateObject("component", "wheelsMapping.Cache").init(storage="memory", strategy="age")>

	<cffunction name="setup">
		<cfset StructDelete(variables, "result")>
		<cfset StructDelete(variables, "results")>
	</cffunction>

	<cffunction name="testComplexValue">
		<cfset var loc = {}>
		<cfset loc.aQuery = QueryNew("col1,col2")>
		<cfset pkg.cache.add(key="myQ", value=loc.aQuery)>
		<cfset result = pkg.cache.get(key="myQ")>
		<cfset assert("IsQuery(result) AND result.recordCount IS 0")>
	</cffunction>

	<cffunction name="testExpiration">
		<cfset var loc = {}>
		<cfset pkg.cache.add(key="1", value="a")>
		<cfset result = pkg.cache.get(key="1")>
		<cfset assert("result IS 'a'")>
		<cfset loc.currentTime = DateAdd("n", 65, Now())>
		<cfset result = pkg.cache.get(key="1", currentTime=loc.currentTime)>
		<cfset assert("IsBoolean(result) AND NOT result")>
	</cffunction>

</cfcomponent>