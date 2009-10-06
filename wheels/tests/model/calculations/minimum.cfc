<cfcomponent extends="wheels.test">

	<cfset global.controller = createobject("component", "wheels.controller") />
	
	<cffunction name="test_minimum_valid">
		<cfset assert("1 eq 0") />
	</cffunction>
	
</cfcomponent>