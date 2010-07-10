<cfcomponent extends="wheelsMapping.test">
	
	<cffunction name="setup">
		<cfset loc.author = model("author")>
		<cfset loc.profile = model("profile")>
	</cffunction>
	
	<cffunction name="test_add_child_via_struct">
		<cfset loc.a = loc.author.findOneByLastName("Peters")>
		<cfset loc.bioText = "Loves learning how to write tests.">
		<cfset loc.a.profile = {dateOfBirth="10/02/1980 18:00:00", bio=loc.bioText}>
		<cfset assert("loc.a.save()")>
		<cfset loc.p = loc.profile.findOneByBio(loc.bioText)>
		<cfset assert("IsObject(loc.p)")>
	</cffunction>
	
</cfcomponent>