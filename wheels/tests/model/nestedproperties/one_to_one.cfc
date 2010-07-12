<cfcomponent extends="wheelsMapping.test">
	
	<cffunction name="setup">
		<cfset loc.author = model("author")>
		<cfset loc.profile = model("profile")>
	</cffunction>
	
	<cffunction name="test_add_child_via_object">
		<cfset loc.a = loc.author.findOneByLastName(value="Peters", include="profile")>
		<cfset loc.bioText = "Loves learning how to write tests." />
		<cfset loc.a.profile = model("profile").new(dateOfBirth="10/02/1980 18:00:00", bio=loc.bioText)>
		<cftransaction action="begin">
			<cfset assert("loc.a.save()")>
			<cfset loc.p = loc.profile.findByKey(loc.a.profile.id)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert("IsObject(loc.p)")>
	</cffunction>
	
</cfcomponent>