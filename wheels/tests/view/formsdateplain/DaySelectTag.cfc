<cfcomponent extends="wheelsMapping.test">

	<cfset controller = $controller(name="dummy")>

	<cffunction name="_test_x">
		<cfset assert("1 IS 1")>
	</cffunction>

</cfcomponent>