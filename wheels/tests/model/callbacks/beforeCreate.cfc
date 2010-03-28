<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_new_object">
		<cfset model("tag").$registerCallback(type="beforeCreate", methods="callbackThatSetsProperty,callbackThatReturnsFalse")>
		<cfset loc.obj = model("tag").create()>
		<cfset model("tag").$clearCallbacks(type="beforeCreate")>
		<cfset assert("StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>

	<cffunction name="test_new_object_with_skipped_callback">
		<cfset model("tag").$registerCallback(type="beforeCreate", methods="callbackThatSetsProperty,callbackThatReturnsFalse")>
		<cfset loc.obj = model("tag").create(name="mustSetAtLeastOnePropertyOrCreateFails", transaction="rollback", callbacks=false)>
		<cfset model("tag").$clearCallbacks(type="beforeCreate")>
		<cfset assert("NOT StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>

	<cffunction name="test_existing_object">
		<cfset model("tag").$registerCallback(type="beforeCreate", methods="callbackThatSetsProperty")>
		<cfset model("tag").$registerCallback(type="beforeUpdate", methods="callbackThatReturnsFalse")>
		<cfset loc.obj = model("tag").findOne()>
		<cfset loc.obj.name = "somethingElse">
		<cfset loc.obj.save()>
		<cfset model("tag").$clearCallbacks(type="beforeCreate")>
		<cfset model("tag").$clearCallbacks(type="beforeUpdate")>
		<cfset assert("NOT StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>

</cfcomponent>