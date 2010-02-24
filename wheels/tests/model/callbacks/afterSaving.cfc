<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_chain_when_saving_existing_object">
		<cfset model("tag").$registerCallback(type="afterValidation", methods="callbackThatIncreasesVariable")>
		<cfset model("tag").$registerCallback(type="afterValidationOnCreate", methods="callbackThatIncreasesVariable")>
		<cfset model("tag").$registerCallback(type="afterValidationOnUpdate", methods="callbackThatIncreasesVariable")>
		<cfset model("tag").$registerCallback(type="afterSave", methods="callbackThatIncreasesVariable")>
		<cfset model("tag").$registerCallback(type="afterCreate", methods="callbackThatIncreasesVariable")>
		<cfset model("tag").$registerCallback(type="afterUpdate", methods="callbackThatIncreasesVariable")>
		<cfset loc.obj = model("tag").findOne()>
		<cfset loc.obj.name = "somethingElse">
		<cftransaction>
			<cfset loc.obj.save(transaction="none")>
			<cftransaction action="rollback"/>
		</cftransaction>
		<cfset model("tag").$clearCallbacks(type="afterValidation")>
		<cfset model("tag").$clearCallbacks(type="afterValidationOnCreate")>
		<cfset model("tag").$clearCallbacks(type="afterValidationOnUpdate")>
		<cfset model("tag").$clearCallbacks(type="afterSave")>
		<cfset model("tag").$clearCallbacks(type="afterCreate")>
		<cfset model("tag").$clearCallbacks(type="afterUpdate")>
		<cfset assert("loc.obj.callbackCount IS 4")>
	</cffunction>

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