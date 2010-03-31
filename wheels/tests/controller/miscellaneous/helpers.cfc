<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cfset controller = $controller(name="dummy").$createControllerObject({controller="dummy",action="dummy"})>
	
	<!---<cffunction name="test_inclusion_of_global_helper_file">
		<cfset assert("1 IS 0")>
	</cffunction>--->
	
	<!---<cffunction name="test_inclusion_of_controller_helper_file">
		<cfset assert("1 IS 0")>
	</cffunction>--->

</cfcomponent>
