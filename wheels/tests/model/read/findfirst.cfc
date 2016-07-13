<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_find_first">
		<cfset loc.result = model("user").findFirst()>
		<cfset assert('loc.result.id IS 1')>
		<cfset loc.result = model("user").findFirst(property="firstName")>
		<cfset assert("loc.result.firstName IS 'Chris'")>
		<cfset loc.result = model("user").findFirst(properties="firstName")>
		<cfset assert("loc.result.firstName IS 'Chris'")>
		<cfset loc.result = model("user").findFirst(property="firstName", where="id != 2")>
		<cfset assert("loc.result.firstName IS 'Joe'")>
	</cffunction>

</cfcomponent>