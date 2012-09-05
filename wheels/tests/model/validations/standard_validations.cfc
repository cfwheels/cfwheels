<cfcomponent extends="wheelsMapping.Test">

 	<cffunction name="setup">
		<cfset StructDelete(application.wheels.models, "users", false)>
        <cfset loc.user = model("users").new()>
	</cffunction>

	<!--- validatesConfirmationOf --->
	<cffunction name="test_validatesConfirmationOf_valid">
		<cfset loc.user.password = "hamsterjelly">
		<cfset loc.user.passwordConfirmation = "hamsterjelly">
		<cfset loc.user.validatesConfirmationOf(property="password")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesConfirmationOf_invalid">
		<cfset loc.user.password = "hamsterjelly">
		<cfset loc.user.passwordConfirmation = "hamsterjellysucks">
		<cfset loc.user.validatesConfirmationOf(property="password")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesConfirmationOf_missing_property_valid">
		<cfset loc.user.passwordConfirmation = "hamsterjellysucks">
		<cfset loc.user.validatesConfirmationOf(property="password")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesConfirmationOf_missing_property_confirmation_valid">
		<cfset loc.user.password = "hamsterjelly">
		<cfset loc.user.validatesConfirmationOf(property="password")>
		<cfset assert('loc.user.valid()')>
	</cffunction>


	<!--- validatesExclusionOf --->
	<cffunction name="test_validatesExclusionOf_valid">
		<cfset loc.user.firstname = "tony">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesExclusionOf_invalid">
		<cfset loc.user.firstname = "tony">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris, tony")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesExclusionOf_missing_property_invalid">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris, tony")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesExclusionOf_missing_property_valid">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris, tony", allowblank="true")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesExclusionOf_allowblank_valid">
		<cfset loc.user.firstname = "">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris", allowblank="true")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesExclusionOf_allowblank_invalid">
		<cfset loc.user.firstname = "">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris", allowblank="false")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>


	<!--- validatesFormatOf --->
	<cffunction name="test_validatesFormatOf_valid">
		<cfset loc.user.phone = "954-555-1212">
		<cfset loc.user.validatesFormatOf(property="phone", regex="(\d{3,3}-){2,2}\d{4,4}")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesFormatOf_invalid">
		<cfset loc.user.phone = "(954) 555-1212">
		<cfset loc.user.validatesFormatOf(property="phone", regex="(\d{3,3}-){2,2}\d{4,4}")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesFormatOf_missing_property_invalid">
		<cfset loc.user.validatesFormatOf(property="phone", regex="(\d{3,3}-){2,2}\d{4,4}")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesFormatOf_missing_property_valid">
		<cfset loc.user.validatesFormatOf(property="phone", regex="(\d{3,3}-){2,2}\d{4,4}", allowBlank="true")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesFormatOf_allowblank_valid">
		<cfset loc.user.phone = "">
		<cfset loc.user.validatesFormatOf(property="phone", regex="(\d{3,3}-){2,2}\d{4,4}", allowBlank="true")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesFormatOf_allowblank_invalid">
		<cfset loc.user.phone = "">
		<cfset loc.user.validatesFormatOf(property="phone", regex="(\d{3,3}-){2,2}\d{4,4}", allowBlank="false")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>


	<!--- validatesInclusionOf --->
	<cffunction name="test_validatesInclusionOf_invalid">
		<cfset loc.user.firstname = "tony">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesInclusionOf_valid">
		<cfset loc.user.firstname = "tony">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris, tony")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesInclusionOf_missing_property_invalid">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris, tony")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesInclusionOf_missing_property_valid">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris, tony", allowblank="true")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesInclusionOf_allowblank_valid">
		<cfset loc.user.firstname = "">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris", allowblank="true")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesInclusionOf_allowblank_invalid">
		<cfset loc.user.firstname = "">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris", allowblank="false")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>


	<!--- validatesLengthOf --->
	<cffunction name="test_validatesLengthOf_maximum_minimum_invalid">
		<cfset loc.user.firstname = "thi">
		<cfset loc.user.validatesLengthOf(property="firstname", minimum="5", maximum="20")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>
	
	<cffunction name="test_validatesLengthOf_maximum_valid">
		<cfset loc.user.firstname = "thisisatestagain">
		<cfset loc.user.validatesLengthOf(property="firstname", maximum="20")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesLengthOf_maximum_invalid">
		<cfset loc.user.firstname = "thisisatestagain">
		<cfset loc.user.validatesLengthOf(property="firstname", maximum="15")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesLengthOf_missing_property_invalid">
		<cfset loc.user.validatesLengthOf(property="firstname", maximum="15")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesLengthOf_missing_property_valid">
		<cfset loc.user.validatesLengthOf(property="firstname", maximum="15", allowblank="true")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesLengthOf_minimum_valid">
		<cfset loc.user.firstname = "thisisatestagain">
		<cfset loc.user.validatesLengthOf(property="firstname", minimum="15")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesLengthOf_minimum_invalid">
		<cfset loc.user.firstname = "thisisatestagain">
		<cfset loc.user.validatesLengthOf(property="firstname", minimum="20")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesLengthOf_within_valid">
		<cfset loc.user.firstname = "thisisatestagain">
		<cfset loc.user.validatesLengthOf(property="firstname", within="15,20")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesLengthOf_within_invalid">
		<cfset loc.user.firstname = "thisisatestagain">
		<cfset loc.user.validatesLengthOf(property="firstname", within="10,15")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesLengthOf_exactly_valid">
		<cfset loc.user.firstname = "thisisatestagain">
		<cfset loc.user.validatesLengthOf(property="firstname", exactly="16")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesLengthOf_exactly_invalid">
		<cfset loc.user.firstname = "thisisatestagain">
		<cfset loc.user.validatesLengthOf(property="firstname", exactly="20")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesLengthOf_allowblank_valid">
		<cfset loc.user.firstname = "">
		<cfset loc.user.validatesLengthOf(property="firstname", allowblank="true")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesLengthOf_allowblank_invalid">
		<cfset loc.user.firstname = "">
		<cfset loc.user.validatesLengthOf(property="firstname", allowblank="false")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>


	<!--- validatesNumericalityOf --->
	<cffunction name="test_validatesNumericalityOf_valid">
		<cfset loc.user.birthdaymonth = "10">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth")>
		<cfset assert('loc.user.valid()')>
	</cffunction>
	
	<cffunction name="test_validatesNumericalityOf_float">
		<cfset loc.user.birthdaymonth = "10.25">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_invalid">
		<cfset loc.user.birthdaymonth = "1,000.00">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>
	
	<cffunction name="test_validatesNumericalityOf_invalid_float">
		<cfset loc.user.birthdaymonth = "1,000.00.25">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_missing_property_invalid">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", onlyInteger="true")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_missing_property_valid">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", onlyInteger="true", allowblank="true")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_onlyInteger_valid">
		<cfset loc.user.birthdaymonth = "1000">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", onlyInteger="true")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_onlyInteger_invalid">
		<cfset loc.user.birthdaymonth = "1000.25">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", onlyInteger="true")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_allowBlank_valid">
		<cfset loc.user.birthdaymonth = "">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", allowBlank="true")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_allowBlank_invalid">
		<cfset loc.user.birthdaymonth = "">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", allowBlank="false")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_greaterThan_valid">
		<cfset loc.user.birthdaymonth = "11">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", greaterThan="10")>
		<cfset assert('loc.user.valid()')>
	</cffunction>
	
	<cffunction name="test_validatesNumericalityOf_greaterThan_valid_float">
		<cfset loc.user.birthdaymonth = "11.25">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", greaterThan="11.10")>
		<cfset assert('loc.user.valid()')>
	</cffunction>
	
	<cffunction name="test_validatesNumericalityOf_greaterThan_invalid">
		<cfset loc.user.birthdaymonth = "10">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", greaterThan="10")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_greaterThan_invalid_float">
		<cfset loc.user.birthdaymonth = "11.25">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", greaterThan="11.30")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_greaterThanOrEqualTo_valid">
		<cfset loc.user.birthdaymonth = "10">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", greaterThanOrEqualTo="10")>
		<cfset assert('loc.user.valid()')>
	</cffunction>
	
	<cffunction name="test_validatesNumericalityOf_greaterThanOrEqualTo_valid_float">
		<cfset loc.user.birthdaymonth = "11.25">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", greaterThanOrEqualTo="11.25")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_greaterThanOrEqualTo_invalid">
		<cfset loc.user.birthdaymonth = "9">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", greaterThanOrEqualTo="10")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>
	
	<cffunction name="test_validatesNumericalityOf_greaterThanOrEqualTo_invalid_float">
		<cfset loc.user.birthdaymonth = "11.25">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", greaterThanOrEqualTo="11.30")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_equalTo_valid">
		<cfset loc.user.birthdaymonth = "10">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", equalTo="10")>
		<cfset assert('loc.user.valid()')>
	</cffunction>
	
	<cffunction name="test_validatesNumericalityOf_equalTo_valid_float">
		<cfset loc.user.birthdaymonth = "10.25">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", equalTo="10.25")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_equalTo_invalid">
		<cfset loc.user.birthdaymonth = "9">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", equalTo="10")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>
	
	<cffunction name="test_validatesNumericalityOf_equalTo_invalid_float">
		<cfset loc.user.birthdaymonth = "9.25">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", equalTo="9.20")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_lessThan_valid">
		<cfset loc.user.birthdaymonth = "9">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", lessThan="10")>
		<cfset assert('loc.user.valid()')>
	</cffunction>
	
	<cffunction name="test_validatesNumericalityOf_lessThan_valid_float">
		<cfset loc.user.birthdaymonth = "9.25">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", lessThan="9.30")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_lessThan_invalid">
		<cfset loc.user.birthdaymonth = "10">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", lessThan="10")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>
	
	<cffunction name="test_validatesNumericalityOf_lessThan_invalid_float">
		<cfset loc.user.birthdaymonth = "10.25">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", lessThan="10.20")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_lessThanOrEqualTo_valid">
		<cfset loc.user.birthdaymonth = "10">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", lessThanOrEqualTo="10")>
		<cfset assert('loc.user.valid()')>
	</cffunction>
	
	<cffunction name="test_validatesNumericalityOf_lessThanOrEqualTo_valid_float">
		<cfset loc.user.birthdaymonth = "10.25">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", lessThanOrEqualTo="10.25")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_lessThanOrEqualTo_invalid">
		<cfset loc.user.birthdaymonth = "11">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", lessThanOrEqualTo="10")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>
	
	<cffunction name="test_validatesNumericalityOf_lessThanOrEqualTo_invalid_float">
		<cfset loc.user.birthdaymonth = "11.25">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", lessThanOrEqualTo="11.20")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_odd_valid">
		<cfset loc.user.birthdaymonth = "13">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", odd="true")>
		<cfset assert('loc.user.valid()')>
	</cffunction>
	
	<cffunction name="test_validatesNumericalityOf_odd_valid_float">
		<cfset loc.user.birthdaymonth = "13.25">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", odd="true")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_odd_invalid">
		<cfset loc.user.birthdaymonth = "14">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", odd="true")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>
	
	<cffunction name="test_validatesNumericalityOf_odd_invalid_float">
		<cfset loc.user.birthdaymonth = "14.25">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", odd="true")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_even_valid">
		<cfset loc.user.birthdaymonth = "14">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", even="true")>
		<cfset assert('loc.user.valid()')>
	</cffunction>
	
	<cffunction name="test_validatesNumericalityOf_even_valid_float">
		<cfset loc.user.birthdaymonth = "14.25">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", even="true")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_even_invalid">
		<cfset loc.user.birthdaymonth = "13">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", even="true")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>
	
	<cffunction name="test_validatesNumericalityOf_even_invalid_float">
		<cfset loc.user.birthdaymonth = "13.25">
		<cfset loc.user.validatesNumericalityOf(property="birthdaymonth", even="true")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<!--- validatesPresenceOf --->
	<cffunction name="test_validatesPresenceOf_valid">
		<cfset loc.user.firstname = "tony">
		<cfset loc.user.validatesPresenceOf(property="firstname")>
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesPresenceOf_invalid">
		<cfset loc.user.validatesPresenceOf(property="firstname")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validatesPresenceOf_invalid_when_blank">
		<cfset loc.user.firstname = "   ">
		<cfset loc.user.validatesPresenceOf(property="firstname")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>


	<!--- validatesUniquenessOf --->
	<cffunction name="test_validatesUniquenessOf_valid">
		<cfset loc.user.firstname = "Tony">
		<cfset loc.user.validatesUniquenessOf(property="firstname")>
		<cfset assert('!loc.user.valid()')>
	</cffunction>
	
	<cffunction name="test_validatesUniquenessOf_valids_when_updating_existing_record">
		<cfset loc.user = model("users").findOne(where="firstname = 'Tony'")>
		<cfset loc.user.validatesUniquenessOf(property="firstname")>
		<cfset assert('loc.user.valid()')>
	</cffunction>
	
	<cffunction name="test_validatesUniquenessOf_takes_softdeletes_into_account">
			<cftransaction action="begin">
			<cfset loc.org_post = model('post').findOne()>
			<cfset loc.properties = loc.org_post.properties()>
			<cfset loc.new_post = model('post').new(loc.properties)>
			<cfset loc.org_post.delete()>
			<cfset loc.valid = loc.new_post.valid()>
			<cfset assert('loc.valid eq false')>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>
	

	<!--- <cffunction name="test_validatesUniquenessOf_with_blank_property_value">
		<cfset loc.user.firstname = "">
		<cfset loc.user.validatesUniquenessOf(property="firstname")>
		<cfset assert('loc.user.valid()')>
	</cffunction> --->

	<!--- validate --->
	<cffunction name="test_validate_registering_methods">
		<cfset loc.user.firstname = "tony">
		<cfset loc.user.validate(method="fakemethod")>
		<cfset loc.user.validate(method="fakemethod2", when="onCreate")>
		<cfset loc.v = loc.user.$classData().validations>
		<cfset loc.onsave = loc.v["onsave"]>
		<cfset loc.oncreate = loc.v["oncreate"]>
		<cfset assert('arraylen(loc.onsave) eq 1')>
		<cfset assert('loc.onsave[1].method eq "fakemethod"')>
		<cfset assert('arraylen(loc.oncreate) eq 1')>
		<cfset assert('loc.oncreate[1].method eq "fakemethod2"')>
	</cffunction>


</cfcomponent>