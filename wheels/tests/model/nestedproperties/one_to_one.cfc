<cfcomponent extends="wheelsMapping.test">
	
	<cffunction name="setup">
		<cfset loc.author = model("author")>
	</cffunction>
	
	<cffunction name="test_add_child_via_struct">
		<cfset loc.a = loc.author.findByKey(2)>
		<cfset loc.a.profile = {authorID=2, dateOfBirth="10/02/1980 18:00:00", bio="Loves learning how to write tests. Stress tests have a new meaning."}>
		<cfset loc.saveSuccess = loc.a.save()>
		<cfset assert("loc.saveSuccess")>
		<cfset loc.a = loc.author.findByKey(key=2, include="profile")>
		<cfset assert("IsDefined('loc.a.profile.id') and IsNumeric(loc.a.profile.id)")>
	</cffunction>
	
</cfcomponent>