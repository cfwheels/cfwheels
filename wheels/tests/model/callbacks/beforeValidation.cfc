<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset model("tag").$registerCallback(type="beforeValidation", methods="callbackThatSetsProperty,callbackThatReturnsFalse")>
		<cfset loc.obj = model("tag").findOne()>
		<cfset loc.obj.name = "somethingElse">	
	</cffunction>
	
	<cffunction name="teardown">
		<cfset model("tag").$clearCallbacks(type="beforeValidation")>
	</cffunction>

	<cffunction name="test_saving_object">
		<cfset loc.obj.save()>
		<cfset assert("StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>

	<cffunction name="test_saving_object_without_callbacks">
		<cfset loc.obj.save(callbacks=false, transaction="rollback")>
		<cfset assert("NOT StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>

</cfcomponent>