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

</cfcomponent>