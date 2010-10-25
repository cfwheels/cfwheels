<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_have_access_to_changed_property_values_in_aftersave">
		<cfset model("user").$registerCallback(type="afterSave", methods="saveHasChanged")>
		<cfset loc.obj = model("user").findOne(where="username = 'tonyp'")>
		<cfset loc.obj.saveHasChanged = saveHasChanged>
		<cfset loc.obj.getHasObjectChanged = getHasObjectChanged>
		<cfset assert('loc.obj.hasChanged() eq false')>
		<cfset loc.obj.password = "xxxxxxx">
		<cfset assert('loc.obj.hasChanged() eq true')>
		<cftransaction>
			<cfset loc.obj.save(transaction="none")>
			<cfset assert('loc.obj.getHasObjectChanged() eq true')>
			<cfset assert('loc.obj.hasChanged() eq false')>
			<cftransaction action="rollback"/>
		</cftransaction>
		<cfset model("user").$clearCallbacks(type="afterSave")>
	</cffunction>

	<cffunction name="saveHasChanged">
		<cfset hasObjectChanged = hasChanged()>
	</cffunction>

	<cffunction name="getHasObjectChanged">
		<cfreturn hasObjectChanged>
	</cffunction>

</cfcomponent>