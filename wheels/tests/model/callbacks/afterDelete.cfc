<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset model("tag").$registerCallback(type="afterDelete", methods="callbackThatSetsProperty")>
		<cfset loc.obj = model("tag").findOne()>	
	</cffunction>
	
	<cffunction name="teardown">
		<cfset model("tag").$clearCallbacks(type="afterDelete")>
	</cffunction>

	<cffunction name="test_existing_object">
		<cftransaction>
			<cfset loc.obj.delete(transaction="none")>
			<cftransaction action="rollback"/>
		</cftransaction>
		<cfset assert("StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>

	<cffunction name="test_existing_object_with_skipped_callback">
		<cftransaction>
			<cfset loc.obj.delete(transaction="none", callbacks="false")>
			<cftransaction action="rollback"/>
		</cftransaction>
		<cfset assert("NOT StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>

</cfcomponent>