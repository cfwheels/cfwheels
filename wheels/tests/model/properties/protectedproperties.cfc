<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_property_cannot_be_set_with_mass_assignment_when_protected">
		<cfset loc.model = model("post") />
		<cfset loc.model = duplicate(loc.model)>
		<cfset loc.model.protectedProperties(properties="views") />
		<cfset loc.properties = { views = "2000" } />
		<cfset loc.model = loc.model.new(properties=loc.properties) />
		<cfset assert('StructKeyExists(loc.model, "views") eq false') />
	</cffunction>

	<cffunction name="test_property_can_be_set_directly">
		<cfset loc.model = model("post") />
		<cfset loc.model = duplicate(loc.model)>
		<cfset loc.model.protectedProperties(properties="views") />
		<cfset loc.model = loc.model.new() />
		<cfset loc.model.views = 2000 />
		<cfset assert('StructKeyExists(loc.model, "views") eq true') />
	</cffunction>

</cfcomponent>