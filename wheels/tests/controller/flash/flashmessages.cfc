<cfcomponent extends="wheelsMapping.test">

	<cfset params = {controller="dummy", action="dummy"}>
	<cfset controller = $controller(name="dummy").$createControllerObject(params)>

	<cffunction name="setup">
		<cfset flashStorage = application.wheels.flashStorage>
		<cfset application.wheels.flashStorage = "cookie">
		<cfset controller.flashClear()>
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.flashStorage = flashStorage>
	</cffunction>

	<cffunction name="test_normal_output">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset controller.flashInsert(alert="Error!")>
		<cfset result = controller.flashMessages()>
		<cfset assert("result IS '<div class=""flash-messages""><p class=""alert-message"">Error!</p><p class=""success-message"">Congrats!</p></div>'")>
	</cffunction>

	<cffunction name="test_specific_key_only">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset controller.flashInsert(alert="Error!")>
		<cfset result = controller.flashMessages(key="alert")>
		<cfset assert("result IS '<div class=""flash-messages""><p class=""alert-message"">Error!</p></div>'")>
	</cffunction>

	<cffunction name="test_passing_through_id">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset result = controller.flashMessages(id="my-id")>
		<cfset assert("result Contains '<p class=""success-message"">Congrats!</p>' AND result Contains 'id=""my-id""'")>
	</cffunction>

	<cffunction name="test_empty_flash">
		<cfset result = controller.flashMessages()>
		<cfset assert("result IS ''")>
	</cffunction>
	
	<cffunction name="test_empty_flash_includeEmptyContainer">
		<cfset result = controller.flashMessages(includeEmptyContainer="true")>
		<cfset assert("result IS '<div class=""flash-messages""></div>'")>
	</cffunction>

	<cffunction name="test_skipping_complex_values">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset arr = []>
		<cfset arr[1] = "test">
		<cfset controller.flashInsert(alert=arr)>
		<cfset result = controller.flashMessages()>
		<cfset assert("result IS '<div class=""flash-messages""><p class=""success-message"">Congrats!</p></div>'")>
	</cffunction>
	
	<cffunction name="test_control_order_via_keys_argument">
		<cfset controller.flashInsert(success="Congrats!")>
		<cfset controller.flashInsert(alert="Error!")>
		<cfset result = controller.flashMessages(keys="success,alert")>
		<cfset assert("result IS '<div class=""flash-messages""><p class=""success-message"">Congrats!</p><p class=""alert-message"">Error!</p></div>'")>
		<cfset result = controller.flashMessages(keys="alert,success")>
		<cfset assert("result IS '<div class=""flash-messages""><p class=""alert-message"">Error!</p><p class=""success-message"">Congrats!</p></div>'")>
	</cffunction>


</cfcomponent>
