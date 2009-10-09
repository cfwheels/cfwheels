<cfcomponent extends="wheelsMapping.test">

	<cfset global.controller = createobject("component", "wheelsMapping.controller") />
	
	<cffunction name="test_count_valid">
		<cfset fail()>
	</cffunction>
	
</cfcomponent>