<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_new_object">
		<cfset model("tag").$registerCallback(type="beforeUpdate", methods="callbackThatSetsProperty")>
		<cfset model("tag").$registerCallback(type="beforeCreate", methods="callbackThatReturnsFalse")>
		<cfset loc.obj = model("tag").create()>
		<cfset model("tag").$clearCallbacks(type="beforeUpdate")>
		<cfset model("tag").$clearCallbacks(type="beforeCreate")>
		<cfset assert("NOT StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>

	<cffunction name="test_existing_object">
		<cfset model("tag").$registerCallback(type="beforeUpdate", methods="callbackThatSetsProperty,callbackThatReturnsFalse")>
		<cfset loc.obj = model("tag").findOne()>
		<cfset loc.obj.name = "somethingElse">
		<cfset loc.obj.save()>
		<cfset model("tag").$clearCallbacks(type="beforeUpdate")>
		<cfset assert("StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>

</cfcomponent>