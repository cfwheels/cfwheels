<cfcomponent extends="wheelsMapping.test">

	<cffunction name="test_new_object">
		<cfset model("tag").$registerCallback(type="beforeValidationOnCreate", methods="callbackThatSetsProperty,callbackThatReturnsFalse")>
		<cfset loc.obj = model("tag").create()>
		<cfset model("tag").$clearCallbacks(type="beforeValidationOnCreate")>
		<cfset assert("StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>
	
	<cffunction name="test_new_object_with_skipped_callback">
		<cfset model("tag").$registerCallback(type="beforeValidationOnCreate", methods="callbackThatSetsProperty,callbackThatReturnsFalse")>
		<cfset loc.obj = model("tag").create(name="mustSetAtLeastOnePropertyOrCreateFails", transaction="rollback", callbacks=false)>
		<cfset model("tag").$clearCallbacks(type="beforeValidationOnCreate")>
		<cfset assert("NOT StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>
	

</cfcomponent>