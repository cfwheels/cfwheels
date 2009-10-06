<cfcomponent extends="wheels.test">

	<cfset global.controller = createobject("component", "wheels.controller") />
	
	<cffunction name="test_afterInitialization_valid">
		<cfset fail()>
	</cffunction>
	
</cfcomponent>