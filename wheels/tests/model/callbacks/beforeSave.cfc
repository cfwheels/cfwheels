<cfcomponent extends="wheels.test">

	<cfset global.controller = createobject("component", "wheels.controller") />
	
	<cffunction name="test_beforeSave_valid">
		<cfset fail()>
	</cffunction>
	
</cfcomponent>