<cfcomponent extends="wheelsMapping.Test">

	<cfinclude template="setup.cfm">

	<cffunction name="test_normal_output">
		<cfset run_normal_output()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_normal_output()>
	</cffunction>

	<cffunction name="run_normal_output">
		<cfset loc.controller.flashInsert(success="Congrats!")>
		<cfset loc.controller.flashInsert(alert="Error!")>
		<cfset result = loc.controller.flashMessages()>
		<cfset assert("result IS '<div class=""flashMessages""><p class=""alertMessage"">Error!</p><p class=""successMessage"">Congrats!</p></div>'")>
	</cffunction>

	<cffunction name="test_specific_key_only">
		<cfset run_specific_key_only()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_specific_key_only()>
	</cffunction>

	<cffunction name="run_specific_key_only">
		<cfset loc.controller.flashInsert(success="Congrats!")>
		<cfset loc.controller.flashInsert(alert="Error!")>
		<cfset result = loc.controller.flashMessages(key="alert")>
		<cfset assert("result IS '<div class=""flashMessages""><p class=""alertMessage"">Error!</p></div>'")>
	</cffunction>

	<cffunction name="test_passing_through_id">
		<cfset run_passing_through_id()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_passing_through_id()>
	</cffunction>

	<cffunction name="run_passing_through_id">
		<cfset loc.controller.flashInsert(success="Congrats!")>
		<cfset result = loc.controller.flashMessages(id="my-id")>
		<cfset assert("result Contains '<p class=""successMessage"">Congrats!</p>' AND result Contains 'id=""my-id""'")>
	</cffunction>

	<cffunction name="test_empty_flash">
		<cfset run_empty_flash()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_empty_flash()>
	</cffunction>

	<cffunction name="run_empty_flash">
		<cfset result = loc.controller.flashMessages()>
		<cfset assert("result IS ''")>
	</cffunction>

	<cffunction name="test_empty_flash_includeEmptyContainer">
		<cfset run_empty_flash_includeEmptyContainer()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_empty_flash_includeEmptyContainer()>
	</cffunction>

	<cffunction name="run_empty_flash_includeEmptyContainer">
		<cfset result = loc.controller.flashMessages(includeEmptyContainer="true")>
		<cfset assert("result IS '<div class=""flashMessages""></div>'")>
	</cffunction>

	<cffunction name="test_skipping_complex_values">
		<cfset run_skipping_complex_values()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_skipping_complex_values()>
	</cffunction>

	<cffunction name="run_skipping_complex_values">
		<cfset loc.controller.flashInsert(success="Congrats!")>
		<cfset arr = []>
		<cfset arr[1] = "test">
		<cfset loc.controller.flashInsert(alert=arr)>
		<cfset result = loc.controller.flashMessages()>
		<cfset assert("result IS '<div class=""flashMessages""><p class=""successMessage"">Congrats!</p></div>'")>
	</cffunction>

	<cffunction name="test_control_order_via_keys_argument">
		<cfset run_control_order_via_keys_argument()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_control_order_via_keys_argument()>
	</cffunction>

	<cffunction name="run_control_order_via_keys_argument">
		<cfset loc.controller.flashInsert(success="Congrats!")>
		<cfset loc.controller.flashInsert(alert="Error!")>
		<cfset result = loc.controller.flashMessages(keys="success,alert")>
		<cfset assert("result IS '<div class=""flashMessages""><p class=""successMessage"">Congrats!</p><p class=""alertMessage"">Error!</p></div>'")>
		<cfset result = loc.controller.flashMessages(keys="alert,success")>
		<cfset assert("result IS '<div class=""flashMessages""><p class=""alertMessage"">Error!</p><p class=""successMessage"">Congrats!</p></div>'")>
	</cffunction>

	<cffunction name="test_casing_of_class_attribute">
		<cfset run_casing_of_class_attribute()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_casing_of_class_attribute()>
	</cffunction>

	<cffunction name="run_casing_of_class_attribute">
 		<cfset loc.controller.flashInsert(something="")>
		<cfset loc.r = loc.controller.flashMessages()>
		<cfif application.wheels.serverName eq "Railo">
			<cfset loc.e = 'class="SOMETHINGMessage"'>
		<cfelse>
			<cfset loc.e = 'class="somethingMessage"'>
		</cfif>
		<cfset assert('Find(loc.e, loc.r)')>
		<cfset loc.controller.flashInsert(someThing="")>
	</cffunction>

	<cffunction name="test_casing_of_class_attribute_mixed">
		<cfset run_casing_of_class_attribute_mixed()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_casing_of_class_attribute_mixed()>
	</cffunction>

	<cffunction name="run_casing_of_class_attribute_mixed">
		<!---
		https://jira.jboss.org/browse/RAILO-933
		note that a workaround for RAILO is to quote the arugment:
		<cfset controller.flashInsert("someThing"="")>
		Just remember that this throws a compilation error in ACF
		 --->
		<cfset loc.controller.flashInsert(someThing="")>
		<cfset loc.r = loc.controller.flashMessages()>
		<cfset loc.r = loc.controller.flashMessages()>
		<cfif application.wheels.serverName eq "Railo">
			<cfset loc.e = 'class="SOMETHINGMessage"'>
		<cfelse>
			<cfset loc.e = 'class="someThingMessage"'>
		</cfif>
		<cfset assert('Find(loc.e, loc.r)')>
	</cffunction>

	<cffunction name="test_casing_of_class_attribute_upper">
		<cfset run_casing_of_class_attribute_upper()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_casing_of_class_attribute_upper()>
	</cffunction>

	<cffunction name="run_casing_of_class_attribute_upper">
		<cfset loc.controller.flashInsert(SOMETHING="")>
		<cfset loc.r = loc.controller.flashMessages()>
		<cfset loc.e = 'class="SOMETHINGMessage"'>
		<cfset assert('Find(loc.e, loc.r)')>
	</cffunction>

	<cffunction name="test_setting_class">
		<cfset run_setting_class()>
		<cfset loc.controller.$setFlashStorage("cookie")>
		<cfset run_setting_class()>
	</cffunction>

	<cffunction name="run_setting_class">
		<cfset loc.controller.flashInsert(success="test")>
		<cfset loc.r = loc.controller.flashMessages(class="custom-class")>
		<cfset loc.e = 'class="custom-class"'>
		<cfif application.wheels.serverName eq "Railo">
			<cfset loc.e2 = 'class="SUCCESSMessage"'>
		<cfelse>
			<cfset loc.e2 = 'class="successMessage"'>
		</cfif>
		<cfset assert('Find(loc.e, loc.r) AND Find(loc.e2, loc.r)')>
	</cffunction>

</cfcomponent>