<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_existing_object">
		<cfset model("tag").$registerCallback(type="afterDelete", methods="callbackThatSetsProperty")>
		<cfset loc.obj = model("tag").findOne()>
		<cftransaction>
			<cfset loc.obj.delete(transaction="none")>
			<cftransaction action="rollback"/>
		</cftransaction>
		<cfset model("tag").$clearCallbacks(type="afterDelete")>
		<cfset assert("StructKeyExists(loc.obj, 'setByCallback')")>
	</cffunction>

</cfcomponent>