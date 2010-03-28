<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_existing_object">
		<cfset model("tag").$registerCallback(type="beforeValidationOnUpdate", methods="callbackThatSetsProperty,callbackThatReturnsFalse")>
		<cfset loc.obj = model("tag").findOne()>
		<cfset loc.obj.name = "somethingElse">
		<cfset loc.obj.save()>
		<cfset model("tag").$clearCallbacks(type="beforeValidationOnUpdate")>
		<cfset assert("StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>

	<cffunction name="test_existing_object_with_skipped_callback">
		<cfset model("tag").$registerCallback(type="beforeValidationOnUpdate", methods="callbackThatSetsProperty,callbackThatReturnsFalse")>
		<cfset loc.obj = model("tag").findOne()>
		<cfset loc.obj.name = "somethingElse">
		<cfset loc.obj.save(callbacks=false, transaction="rollback")>
		<cfset model("tag").$clearCallbacks(type="beforeValidationOnUpdate")>
		<cfset assert("NOT StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>

</cfcomponent>