<cfcomponent extends="wheels.test">

	<cfset global.controller = createobject("component", "wheels.controller") />
	
	<cffunction name="test_beforeValidationOnCreate_valid">
		<cfset fail()>
	</cffunction>
	
</cfcomponent>