<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_new_object">
		<cfset model("tag").$registerCallback(type="beforeValidationOnCreate", methods="callbackThatSetsProperty,callbackThatReturnsFalse")>
		<cfset loc.obj = model("tag").create()>
		<cfset model("tag").$clearCallbacks(type="beforeValidationOnCreate")>
		<cfset assert("StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>

</cfcomponent>