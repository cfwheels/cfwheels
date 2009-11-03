<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsmapping/tests/_assets/testhelpers/load_models.cfm">
	<cfset load_Models("users")>
	
	<cffunction name="test_should_initialize_properties">
		<cfset loc.a = loc.user.new()>
		<cfset loc.b = loc.a.properties()>
		<cfset loc.c = structkeylist(loc.a)>
		<cfloop collection="#loc.b#" item="loc.i">
			<cfset assert('listfindnocase(loc.c, loc.i)')>
		</cfloop>
	</cffunction>

</cfcomponent>