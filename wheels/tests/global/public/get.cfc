<cfcomponent extends="wheels.test">

	<cfset global.controller = createobject("component", "wheels.controller") />

	<cffunction name="test_get_valid">
		<cfset fail()>
	</cffunction>

</cfcomponent>