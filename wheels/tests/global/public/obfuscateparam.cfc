<cfcomponent extends="wheels.test">

	<cfset global.controller = createobject("component", "wheels.controller") />
	
	<cffunction name="test_obfuscateParam_valid">
		<cfset assert("1 eq 0") />
	</cffunction>
	
</cfcomponent>