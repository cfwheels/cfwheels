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
			<cfset loc.obj.save()>
			<cftransaction action="rollback">
		</cftransaction>
		<cfset model("tag").$clearCallbacks(type="afterValidation")>
		<cfset model("tag").$clearCallbacks(type="afterValidationOnCreate")>
		<cfset model("tag").$clearCallbacks(type="afterValidationOnUpdate")>
		<cfset model("tag").$clearCallbacks(type="afterSave")>
		<cfset model("tag").$clearCallbacks(type="afterCreate")>
		<cfset model("tag").$clearCallbacks(type="afterUpdate")>
		<cfset assert("loc.obj.callbackCount IS 4")>
	</cffunction>

</cfcomponent>