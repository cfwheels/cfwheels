<cfcomponent extends="wheelsMapping.test">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

	<cffunction name="setup">
		<cfset session.flash = StructNew()>
		<cfset session.flash.success = "Congrats!">
	</cffunction>
	
	<cffunction name="test_key_exists">
		<cfset result = controller.flash("success")>
		<cfset assert("result IS 'Congrats!'")>
	</cffunction>
	
	<cffunction name="test_key_does_not_exist">
		<cfset result = controller.flash("invalidkey")>
		<cfset assert("result IS ''")>
	</cffunction>
	
	<cffunction name="test_key_is_blank">
		<cfset result = controller.flash("")>
		<cfset assert("result IS ''")>
	</cffunction>	
	
	<cffunction name="test_key_provided_flash_empty">
		<cfset StructClear(session.flash)>
		<cfset result = controller.flash("invalidkey")>
		<cfset assert("result IS ''")>
	</cffunction>
	
	<cffunction name="test_no_key_provided_flash_not_empty">
		<cfset result = controller.flash()>
		<cfset assert("IsStruct(result) AND StructKeyExists(result, 'success')")>
	</cffunction>
	
	<cffunction name="test_no_key_provided_flash_empty">
		<cfset StructClear(session.flash)>
		<cfset result = controller.flash()>
		<cfset assert("IsStruct(result) AND StructIsEmpty(result)")>
	</cffunction>

</cfcomponent>
