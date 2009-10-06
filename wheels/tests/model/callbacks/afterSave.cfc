<cfcomponent extends="wheels.test">

	<cfset global.controller = createobject("component", "wheels.controller") />
	
	<cffunction name="test_afterSave_valid">
		<cfset fail()>
	</cffunction>
	
</cfcomponent>