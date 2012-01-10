<cfcomponent extends="wheelsMapping.Test">

	<cfset cache = CreateObject("component", "wheelsMapping.Cache").init(storage="memory", strategy="age")>

	<cffunction name="setup">
		<cfset cache.clear()>
		<cfset StructDelete(variables, "result")>
		<cfset StructDelete(variables, "results")>
	</cffunction>

	<cffunction name="testOneValue">
		<cfset cache.add(key="1", value="a")>
		<cfset result = cache.count()>
		<cfset assert("result IS 1")>
	</cffunction>

	<cffunction name="testMultipleAndComplexValues">
		<cfset var loc = {}>
		<cfset loc.aQuery = QueryNew("col1,col2")>
		<cfset cache.add(key="1", value="a")>
		<cfset cache.add(key="2", value="b")>
		<cfset cache.add(key="3", value=loc.aQuery)>
		<cfset result = cache.count()>
		<cfset assert("result IS 3")>
	</cffunction>

</cfcomponent>