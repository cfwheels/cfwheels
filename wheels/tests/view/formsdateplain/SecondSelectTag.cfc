<cfcomponent extends="wheelsMapping.Test">

	<cfset loc.controller = controller(name="dummy")>

	<cffunction name="_test_x">
		<cfset assert("1 IS 1")>
	</cffunction>

</cfcomponent>