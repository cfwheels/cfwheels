<cfcomponent extends="wheels.test">

	<cffunction name="_setup">
		<cfset global = {}>
		<cfset global.user = createobject("component", "wheels.model").$initModelClass("Users")>
	</cffunction>

	<cffunction name="setup">
		<cfset loc = {}>
		<cfset loc.user = duplicate(global.user)>
	</cffunction>

	<!--- validatesConfirmationOf --->
	<cffunction name="test_validatesConfirmationOf_valid">
		<cfset loc.user.password = "hamsterjelly">
		<cfset loc.user.passwordConfirmation = "hamsterjelly">
		<cfset loc.user.validatesConfirmationOf(property="password")>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_validatesConfirmationOf_invalid">
		<cfset loc.user.password = "hamsterjelly">
		<cfset loc.user.passwordConfirmation = "hamsterjellysucks">
		<cfset loc.user.validatesConfirmationOf(property="password")>
		<cfset assert_test(loc.user, false)>
	</cffunction>


	<!--- validatesExclusionOf --->
	<cffunction name="test_validatesExclusionOf_valid">
		<cfset loc.user.firstname = "tony">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris")>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_validatesExclusionOf_invalid">
		<cfset loc.user.firstname = "tony">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris, tony")>
		<cfset assert_test(loc.user, false)>
	</cffunction>

	<cffunction name="test_validatesExclusionOf_allowblank_valid">
		<cfset loc.user.firstname = "">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris", allowblank="true")>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_validatesExclusionOf_allowblank_invalid">
		<cfset loc.user.firstname = "">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris", allowblank="false")>
		<cfset assert_test(loc.user, false)>
	</cffunction>


	<!--- validatesFormatOf --->
	<cffunction name="test_validatesFormatOf_valid">
		<cfset loc.user.phone = "954-555-1212">
		<cfset loc.user.validatesFormatOf(property="phone", regex="(\d{3,3}-){2,2}\d{4,4}")>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_validatesFormatOf_invalid">
		<cfset loc.user.phone = "(954) 555-1212">
		<cfset loc.user.validatesFormatOf(property="phone", regex="(\d{3,3}-){2,2}\d{4,4}")>
		<cfset assert_test(loc.user, false)>
	</cffunction>

	<cffunction name="test_validatesFormatOf_allowblank_valid">
		<cfset loc.user.phone = "">
		<cfset loc.user.validatesFormatOf(property="phone", regex="(\d{3,3}-){2,2}\d{4,4}", allowBlank="true")>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_validatesFormatOf_allowblank_invalid">
		<cfset loc.user.phone = "">
		<cfset loc.user.validatesFormatOf(property="phone", regex="(\d{3,3}-){2,2}\d{4,4}", allowBlank="false")>
		<cfset assert_test(loc.user, false)>
	</cffunction>
	

	<!--- validatesInclusionOf --->
	<cffunction name="test_validatesInclusionOf_invalid">
		<cfset loc.user.firstname = "tony">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris")>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_validatesInclusionOf_valid">
		<cfset loc.user.firstname = "tony">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris, tony")>
		<cfset assert_test(loc.user, false)>
	</cffunction>

	<cffunction name="test_validatesInclusionOf_allowblank_valid">
		<cfset loc.user.firstname = "">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris", allowblank="true")>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_validatesInclusionOf_allowblank_invalid">
		<cfset loc.user.firstname = "">
		<cfset loc.user.validatesExclusionOf(property="firstname", list="per, raul, chris", allowblank="false")>
		<cfset assert_test(loc.user, false)>
	</cffunction>
	
	
	<!--- validatesLengthOf --->
	<cffunction name="test_validatesLengthOf_maximum_valid">
		<cfset loc.user.firstname = "thisisatestagain">
		<cfset loc.user.validatesLengthOf(property="firstname", maximum="20")>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_validatesLengthOf_maximum_invalid">
		<cfset loc.user.firstname = "thisisatestagain">
		<cfset loc.user.validatesLengthOf(property="firstname", maximum="15")>
		<cfset assert_test(loc.user, false)>
	</cffunction>
	
	<cffunction name="test_validatesLengthOf_minimum_valid">
		<cfset loc.user.firstname = "thisisatestagain">
		<cfset loc.user.validatesLengthOf(property="firstname", minimum="15")>
		<cfset assert_test(loc.user, true)>
	</cffunction>
	
	<cffunction name="test_validatesLengthOf_minimum_invalid">
		<cfset loc.user.firstname = "thisisatestagain">
		<cfset loc.user.validatesLengthOf(property="firstname", minimum="20")>
		<cfset assert_test(loc.user, false)>
	</cffunction>
	
	<cffunction name="test_validatesLengthOf_within_valid">
		<cfset loc.user.firstname = "thisisatestagain">
		<cfset loc.user.validatesLengthOf(property="firstname", within="15,20")>
		<cfset assert_test(loc.user, true)>
	</cffunction>
	
	<cffunction name="test_validatesLengthOf_within_invalid">
		<cfset loc.user.firstname = "thisisatestagain">
		<cfset loc.user.validatesLengthOf(property="firstname", within="10,15")>
		<cfset assert_test(loc.user, false)>
	</cffunction>
	
	<cffunction name="test_validatesLengthOf_exactly_valid">
		<cfset loc.user.firstname = "thisisatestagain">
		<cfset loc.user.validatesLengthOf(property="firstname", exactly="16")>
		<cfset assert_test(loc.user, true)>
	</cffunction>
	
	<cffunction name="test_validatesLengthOf_exactly_invalid">
		<cfset loc.user.firstname = "thisisatestagain">
		<cfset loc.user.validatesLengthOf(property="firstname", exactly="20")>
		<cfset assert_test(loc.user, false)>
	</cffunction>
	
	<cffunction name="test_validatesLengthOf_allowblank_valid">
		<cfset loc.user.firstname = "">
		<cfset loc.user.validatesLengthOf(property="firstname", allowblank="true")>
		<cfset assert_test(loc.user, true)>
	</cffunction>
	
	<cffunction name="test_validatesLengthOf_allowblank_invalid">
		<cfset loc.user.firstname = "">
		<cfset loc.user.validatesLengthOf(property="firstname", allowblank="false")>
		<cfset assert_test(loc.user, false)>
	</cffunction>
	

	<!--- validatesNumericalityOf --->
	<cffunction name="test_validatesNumericalityOf_valid">
		<cfset loc.user.price = "1000.00">
		<cfset loc.user.validatesNumericalityOf(property="price")>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_invalid">
		<cfset loc.user.price = "1,000.00">
		<cfset loc.user.validatesNumericalityOf(property="price")>
		<cfset assert_test(loc.user, false)>
	</cffunction>
	
	<cffunction name="test_validatesNumericalityOf_onlyInteger_valid">
		<cfset loc.user.price = "1000">
		<cfset loc.user.validatesNumericalityOf(property="price", onlyInteger="true")>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_onlyInteger_invalid">
		<cfset loc.user.price = "1000.25">
		<cfset loc.user.validatesNumericalityOf(property="price", onlyInteger="true")>
		<cfset assert_test(loc.user, false)>
	</cffunction>
	
	<cffunction name="test_validatesNumericalityOf_allowBlank_valid">
		<cfset loc.user.price = "">
		<cfset loc.user.validatesNumericalityOf(property="price", allowBlank="true")>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_validatesNumericalityOf_allowBlank_invalid">
		<cfset loc.user.price = "">
		<cfset loc.user.validatesNumericalityOf(property="price", allowBlank="false")>
		<cfset assert_test(loc.user, false)>
	</cffunction>
	
	
	<!--- validatesPresenceOf --->
	<cffunction name="test_validatesPresenceOf_valid">
		<cfset loc.user.firstname = "tony">
		<cfset loc.user.validatesPresenceOf(property="firstname")>
		<cfset assert_test(loc.user, true)>
	</cffunction>

	<cffunction name="test_validatesPresenceOf_invalid">
		<cfset loc.user.validatesPresenceOf(property="firstname")>
		<cfset assert_test(loc.user, false)>
	</cffunction>
	

	<cffunction name="assert_test">
		<cfargument name="obj" type="any" required="true">
		<cfargument name="expect" type="any" required="true">
		<cfset loc.e = arguments.obj.valid()>
		<cfset assert('loc.e eq #arguments.expect#')>
	</cffunction>

</cfcomponent>