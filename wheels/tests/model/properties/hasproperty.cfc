<cfcomponent extends="wheelsMapping.test">

	<cffunction name="test_propertyIsPresent_returns_true_when_property_is_set">
		<cfset loc.model = model("author") />
		<cfset loc.properties = { firstName = "James", lastName = "Gibson" } />
		<cfset loc.model = loc.model.new(properties=loc.properties) />
		<cfset assert('loc.model.hasProperty("firstName") eq true') />
	</cffunction>

	<cffunction name="test_propertyIsPresent_returns_true_when_property_is_blank">
		<cfset loc.model = model("author").new() />
		<cfset loc.model.firstName = "" />
		<cfset assert('loc.model.hasProperty("lastName") eq false') />
	</cffunction>

	<cffunction name="test_propertyIsPresent_returns_false_when_property_does_not_exist">
		<cfset loc.model = model("author").new() />
		<cfset assert('loc.model.hasProperty("lastName") eq false') />
	</cffunction>

	<cffunction name="test_propertyIsPresent_dynamic_method_call">
		<cfset loc.model = model("author") />
		<cfset loc.properties = { firstName = "James", lastName = "Gibson" } />
		<cfset loc.model = loc.model.new(properties=loc.properties) />
		<cfset assert('loc.model.hasFirstName() eq true') />
	</cffunction>

</cfcomponent>