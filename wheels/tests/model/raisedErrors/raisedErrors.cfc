<cfcomponent extends="wheelsMapping.test">

	<cffunction name="test_table_not_found">
		<cfset loc.e = raised("model('table_not_found')")>
		<cfset debug("loc.e", false)>
		<cfset loc.r = "Wheels.TableNotFound">
		<cfset assert("loc.e eq loc.r")>
	</cffunction>

</cfcomponent>