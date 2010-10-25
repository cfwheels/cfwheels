<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset model("tag").$registerCallback(type="afterValidation", methods="callbackThatIncreasesVariable")>
		<cfset model("tag").$registerCallback(type="afterValidationOnCreate", methods="callbackThatIncreasesVariable")>
		<cfset model("tag").$registerCallback(type="afterValidationOnUpdate", methods="callbackThatIncreasesVariable")>
		<cfset model("tag").$registerCallback(type="afterSave", methods="callbackThatIncreasesVariable")>
		<cfset model("tag").$registerCallback(type="afterCreate", methods="callbackThatIncreasesVariable")>
		<cfset model("tag").$registerCallback(type="afterUpdate", methods="callbackThatIncreasesVariable")>
		<cfset loc.obj = model("tag").findOne()>
		<cfset loc.obj.name = "somethingElse">
	</cffunction>
	
	<cffunction name="teardown">
		<cfset model("tag").$clearCallbacks(type="afterValidation,afterValidationOnCreate,afterValidationOnUpdate,afterSave,afterCreate,afterUpdate")>
	</cffunction>

	<cffunction name="test_chain_when_saving_existing_object">
		<cftransaction>
			<cfset loc.obj.save(transaction="none")>
			<cftransaction action="rollback"/>
		</cftransaction>
		<cfset assert("loc.obj.callbackCount IS 4")>
	</cffunction>

	<cffunction name="test_chain_when_saving_existing_object_with_all_callbacks_skipped">
		<cftransaction>
			<cfset loc.obj.save(transaction="none", callbacks=false)>
			<cftransaction action="rollback"/>
		</cftransaction>
		<cfset assert("NOT StructKeyExists(loc.obj, 'callbackCount')")>
	</cffunction>

</cfcomponent>