<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset results = {}>
	</cffunction>

	<cffunction name="test_one_value">
		<cfset results.user = model("user").findOneByFirstname('Per')>
		<cfset assert("IsObject(results.user)")>
	</cffunction>

	<cffunction name="test_explicit_arguments">
		<cfset results.user = model("user").findOneByZipCode(value="22222", select="id,lastName,zipCode")>
		<cfset assert("IsObject(results.user) AND results.user.lastName IS 'Peters' AND NOT StructKeyExists(results.user, 'firstName')")>
	</cffunction>

	<cffunction name="test_pass_through_order">
		<cfset results.user = model("user").findOneByIsActive(value="1", order="zipCode DESC")>
		<cfset assert("IsObject(results.user) AND results.user.lastName IS 'Riera'")>
	</cffunction>

	<cffunction name="test_two_values">
		<cfset results.user = model("user").findOneByFirstNameAndLastName("Per,Djurner")>
		<cfset assert("IsObject(results.user) AND results.user.lastName IS 'Djurner'")>
	</cffunction>

	<cffunction name="test_two_values_with_space">
		<cfset results.user = model("user").findOneByFirstNameAndLastName("Per, Djurner")>
		<cfset assert("IsObject(results.user) AND results.user.lastName IS 'Djurner'")>
	</cffunction>

	<cffunction name="test_two_values_with_explicit_arguments">
		<cfset results.user = model("user").findOneByFirstNameAndLastName(values="Per,Djurner")>
		<cfset assert("IsObject(results.user) AND results.user.lastName IS 'Djurner'")>
	</cffunction>

	<cffunction name="test_text_data_type">
		<cfset results.profile = model("profile").findOneByBio("ColdFusion Developer")>
		<cfset assert("IsObject(results.profile)")>
	</cffunction>
	
	<cffunction name="test_unlimited_properties_for_dynamic_finders">
		<cfset loc.post = model("Post").findOneByTitleAndAuthoridAndViews(values="Title for first test post|1|5", delimeter="|")>
		<cfset assert('IsObject(loc.post)')>
	</cffunction>
	
	<cffunction name="test_passing_array">
		<cfset loc.args = ["Title for first test post", 1, 5]>
		<cfset loc.post = model("Post").findOneByTitleAndAuthoridAndViews(values=loc.args)>
		<cfset assert('IsObject(loc.post)')>
	</cffunction>
	
	<cffunction name="test_can_change_delimieter_for_dynamic_finders">
		<cfset loc.title = "Testing to make, to make sure, commas work">
		<cftransaction action="begin">
			<cfset loc.post = model("Post").findOne(where="id = 1")>
			<cfset loc.post.title = loc.title>
			<cfset loc.post.save()>
			<cfset loc.post = model("Post").findOneByTitleAndAuthorid(values="#loc.title#|1", delimeter="|")>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('IsObject(loc.post)')>
	</cffunction>
	
	<cffunction name="test_passing_where_clause">
		<cfset loc.post = model("Post").findOneByTitle(value="Title for first test post", where="authorid = 1 AND views = 5")>
		<cfset assert('IsObject(loc.post)')>
	</cffunction>
	
	<cffunction name="test_can_pass_in_commas">
		<cfset loc.title = "Testing to make, to make sure, commas work">
		<cftransaction action="begin">
			<cfset loc.post = model("Post").findOne(where="id = 1")>
			<cfset loc.post.title = loc.title>
			<cfset loc.post.save()>
			<cfset loc.post = model("Post").findOneByTitle(values="#loc.title#")>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('IsObject(loc.post)')>
	</cffunction>

</cfcomponent>