<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_saving_object">
		<cfset model("tag").$registerCallback(type="beforeValidation", methods="callbackThatSetsProperty,callbackThatReturnsFalse")>
		<cfset loc.obj = model("tag").findOne()>
		<cfset loc.obj.name = "somethingElse">
		<cfset loc.obj.save()>
		<cfset model("tag").$clearCallbacks(type="beforeValidation")>
		<cfset assert("StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>

	<cffunction name="test_saving_object_without_callbacks">
		<cfset model("tag").$registerCallback(type="beforeValidation", methods="callbackThatSetsProperty,callbackThatReturnsFalse")>
		<cfset loc.obj = model("tag").findOne()>
		<cfset loc.obj.name = "somethingElse">
		<cfset loc.obj.save(callbacks=false, transaction="rollback")>
		<cfset model("tag").$clearCallbacks(type="beforeValidation")>
		<cfset assert("NOT StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>

</cfcomponent>