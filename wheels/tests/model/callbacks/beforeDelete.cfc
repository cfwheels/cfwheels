<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_existing_object">
		<cfset model("tag").$registerCallback(type="beforeDelete", methods="callbackThatSetsProperty,callbackThatReturnsFalse")>
		<cfset loc.obj = model("tag").findOne()>
		<cfset loc.obj.delete()>
		<cfset model("tag").$clearCallbacks(type="beforeDelete")>
		<cfset assert("StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>

</cfcomponent>