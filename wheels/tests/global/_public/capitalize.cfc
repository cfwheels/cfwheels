<cfcomponent extends="wheelsMapping.Test">

	<cfset global.controller = createobject("component", "wheelsMapping.Controller") />
	
	<cffunction name="test_capitalize_valid">
		<cfset fail()>
	</cffunction>
	
</cfcomponent>