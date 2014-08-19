<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset model("tag").$registerCallback(type="beforeDelete", methods="callbackThatSetsProperty,callbackThatReturnsFalse")>
		<cfset loc.obj = model("tag").findOne()>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset model("tag").$clearCallbacks(type="beforeDelete")>
	</cffunction>

	<cffunction name="test_existing_object">
		<cfset loc.obj.delete()>
		<cfset $assert("StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>

	<cffunction name="test_existing_object_with_skipped_callback">
		<cfif NOT StructKeyExists(server, "bluedragon")>
			<cfset loc.obj.delete(callbacks=false, transaction="rollback")>
			<cfset $assert("NOT StructKeyExists(loc.obj, 'setByCallback')")>
		</cfif>
	</cffunction>

</cfcomponent>