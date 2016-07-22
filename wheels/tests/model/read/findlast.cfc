<cfcomponent extends="wheels.tests.Test">

	<cffunction name="test_find_first">
		<cfset loc.result = model("user").findLast()>
		<cfset assert('loc.result.id IS 5')>
		<cfset loc.result = model("user").findLast(properties="id")>
		<cfset assert('loc.result.id IS 5')>
	</cffunction>

</cfcomponent>