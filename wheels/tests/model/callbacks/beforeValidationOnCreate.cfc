<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset model("tag").$registerCallback(type="beforeValidationOnCreate", methods="callbackThatSetsProperty,callbackThatReturnsFalse")>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset model("tag").$clearCallbacks(type="beforeValidationOnCreate")>
	</cffunction>

	<cffunction name="test_new_object">
		<cfset loc.obj = model("tag").create()>
		<cfset assert("StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>
	
	<cffunction name="test_new_object_with_skipped_callback">
		<cfset loc.obj = model("tag").create(name="mustSetAtLeastOnePropertyOrCreateFails", transaction="rollback", callbacks=false)>
		<cfset assert("NOT StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>

</cfcomponent>