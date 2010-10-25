<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_toggle_property_with_save">
		<cfset loc.model = model("user").findOne(where="firstName='Chris'") />
		<cftransaction action="begin">
			<cfset loc.saved = loc.model.toggle("isActive") />
			<cftransaction action="rollback" />
		</cftransaction>.
		<cfset assert('loc.model.isActive eq false and loc.saved eq true') />
	</cffunction>

	<cffunction name="test_toggle_property_without_save">
		<cfset loc.model = model("user").findOne(where="firstName='Chris'") />
		<cfset loc.model.toggle("isActive", false) />
		<cfset assert('loc.model.isActive eq false') />
	</cffunction>

	<cffunction name="test_toggle_property_dynamic_method_without_save">
		<cfset loc.model = model("user").findOne(where="firstName='Chris'") />
		<cfset loc.model.toggleIsActive(save=false) />
		<cfset assert('loc.model.isActive eq false') />
	</cffunction>

	<cffunction name="test_toggle_property_dynamic_method_with_save">
		<cfset loc.model = model("user").findOne(where="firstName='Chris'") />
		<cftransaction action="begin">
			<cfset loc.saved = loc.model.toggleIsActive() />
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.model.isActive eq false and loc.saved eq true') />
	</cffunction>

	<cffunction name="test_toggle_property_without_save_errors_when_not_existing">
		<cfset loc.model = model("user").findOne(where="firstName='Chris'") />
		<cfset loc.error = raised('loc.model.toggle("isMember", false)') />
		<cfset assert('loc.error eq "Wheels.PropertyDoesNotExist"') />
	</cffunction>

	<cffunction name="test_toggle_property_without_save_errors_when_not_boolean">
		<cfset loc.model = model("user").findOne(where="firstName='Chris'") />
		<cfset loc.error = raised('loc.model.toggle("firstName", false)') />
		<cfset assert('loc.error eq "Wheels.PropertyIsIncorrectType"') />
	</cffunction>

</cfcomponent>