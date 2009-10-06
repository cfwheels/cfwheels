<cfcomponent extends="wheels.test">

	<cfset global.controller = createobject("component", "wheels.controller") />
	
	<cffunction name="test_renderNothing_valid">
		<cfset assert("1 eq 0") />
	</cffunction>
	
	<cffunction name="test_renderPage_valid">
		<cfset assert("1 eq 0") />
	</cffunction>
	
	<cffunction name="test_renderText_valid">
		<cfset assert("1 eq 0") />
	</cffunction>
	
	<cffunction name="test_renderPartial_valid">
		<cfset assert("1 eq 0") />
	</cffunction>
	
</cfcomponent>
