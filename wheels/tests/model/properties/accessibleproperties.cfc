<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_all_properties_can_be_set_by_default">
		<cfset loc.model = model("author") />
		<cfset loc.model = duplicate(loc.model)>
		<cfset loc.properties = { firstName = "James", lastName = "Gibson" } />
		<cfset loc.model = loc.model.new(properties=loc.properties) />
		<cfset assert('StructKeyExists(loc.model, "firstName") eq true') />
		<cfset assert('StructKeyExists(loc.model, "lastName") eq true') />
	</cffunction>

	<cffunction name="test_all_other_properties_cannot_be_set_except_accessible_properties">
		<cfset loc.model = model("post") />
		<cfset loc.model = duplicate(loc.model)>
		<cfset loc.model.accessibleProperties(properties="views") />
		<cfset loc.properties = { views = "2000", averageRating = 4.9, body = "This is the body", title = "this is the title" } />
		<cfset loc.model = loc.model.new(properties=loc.properties) />
		<cfset assert('StructKeyExists(loc.model, "averageRating") eq false') />
		<cfset assert('StructKeyExists(loc.model, "body") eq false') />
		<cfset assert('StructKeyExists(loc.model, "title") eq false') />
		<cfset assert('StructKeyExists(loc.model, "views") eq true') />
	</cffunction>

	<cffunction name="test_all_other_properties_can_be_set_directly">
		<cfset loc.model = model("post") />
		<cfset loc.model = duplicate(loc.model)>
		<cfset loc.model.accessibleProperties(properties="views") />
		<cfset loc.model = loc.model.new() />
		<cfset loc.model.averageRating = 4.9 />
		<cfset loc.model.body = "This is the body" />
		<cfset loc.model.title = "this is the title" />
		<cfset assert('StructKeyExists(loc.model, "averageRating") eq true') />
		<cfset assert('StructKeyExists(loc.model, "body") eq true') />
		<cfset assert('StructKeyExists(loc.model, "title") eq true') />
	</cffunction>

</cfcomponent>