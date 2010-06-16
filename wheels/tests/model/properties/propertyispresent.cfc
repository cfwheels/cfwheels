<cfcomponent extends="wheelsMapping.test">

	<cffunction name="test_propertyIsPresent_returns_true_when_property_is_set">
		<cfset loc.model = model("author") />
		<cfset loc.properties = { firstName = "James", lastName = "Gibson" } />
		<cfset loc.model = loc.model.new(properties=loc.properties) />
		<cfset assert('loc.model.propertyIsPresent("firstName") eq true') />
	</cffunction>

	<cffunction name="test_propertyIsPresent_returns_false_when_property_is_not_set">
		<cfset loc.model = model("author").new() />
		<cfset assert('loc.model.propertyIsPresent("lastName") eq false') />
	</cffunction>

	<cffunction name="test_propertyIsPresent_dynamic_method_call">
		<cfset loc.model = model("author") />
		<cfset loc.properties = { firstName = "James", lastName = "Gibson" } />
		<cfset loc.model = loc.model.new(properties=loc.properties) />
		<cfset assert('loc.model.firstNameIsPresent() eq true') />
	</cffunction>

</cfcomponent>