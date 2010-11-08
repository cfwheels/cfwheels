<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.user = model("UserBlank").new()>
		<cfset loc.user.username = "gavin@cfwheels.org">
		<cfset loc.user.password = "disismypassword">
		<cfset loc.user.firstName = "Gavin">
		<cfset loc.user.lastName = "Gavinsson">
	</cffunction>

	<cffunction name="test_validates_presence_of_invalid">
		<cfset StructDelete(loc.user, "username")> <!--- missing key --->
		<cfset loc.user.password = ""> <!--- zero length string --->
		<cfset loc.user.firstName = "      "> <!--- empty string --->
		<cfset loc.user.valid()>
		<cfset assert('ArrayLen(loc.user.allErrors()) eq 3')>
	</cffunction>

	<cffunction name="test_validates_presence_of_valid">
		<cfset loc.user.password = "something">
		<cfset loc.user.firstName = "blahblah">
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validates_length_of_invalid">
		<cfset loc.user.state = "Too many characters!">
		<cfset loc.user.valid()>
		<cfset loc.arrResult = loc.user.errorsOn("state")>
		<cfset assert('ArrayLen(loc.arrResult) eq 1 AND loc.arrResult[1].message eq "State is the wrong length"')>
	</cffunction>

	<cffunction name="test_validates_length_of_valid">
		<cfset loc.user.state = "FL">
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validates_numericality_of_invalid">
		<cfset loc.user.birthDayMonth = "This is not a number!">
		<cfset loc.user.valid()>
		<cfset loc.arrResult = loc.user.errorsOn("birthDayMonth")>
		<cfset assert('ArrayLen(loc.arrResult) eq 1 AND loc.arrResult[1].message eq "Birthdaymonth is not a number"')>
	</cffunction>

	<cffunction name="test_validates_numericality_of_valid">
		<cfset loc.user.birthDayMonth = "7">
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validates_numericality_of_integer_invalid">
		<cfset loc.user.birthDayMonth = "7.825">
		<cfset loc.user.valid()>
		<cfset loc.arrResult = loc.user.errorsOn("birthDayMonth")>
		<cfset assert('ArrayLen(loc.arrResult) eq 1 AND loc.arrResult[1].message eq "Birthdaymonth is not a number"')>
	</cffunction>

	<cffunction name="test_validates_format_of_date_invalid">
		<cfset loc.user.birthDay = "This is not a date!">
		<cfset loc.user.valid()>
		<cfset loc.arrResult = loc.user.errorsOn("birthDay")>
		<cfset assert('ArrayLen(loc.arrResult) eq 1 AND loc.arrResult[1].message eq "Birth day is invalid"')>
	</cffunction>

	<cffunction name="test_validates_format_of_date_valid">
		<cfset loc.user.birthDay = "01/01/2000">
		<cfset assert('loc.user.valid()')>
	</cffunction>

	<cffunction name="test_validates_format_of_time_invalid">
		<cfset loc.user.birthTime = "This is not a time!">
		<cfset loc.user.valid()>
		<cfset loc.arrResult = loc.user.errorsOn("birthTime")>
		<cfset assert('ArrayLen(loc.arrResult) eq 1 AND loc.arrResult[1].message eq "Birthtime is invalid"')>
	</cffunction>

	<cffunction name="test_validates_format_of_time_valid">
		<cfset loc.user.birthTime = "6:15 PM">
		<cfset assert('loc.user.valid()')>
	</cffunction>

</cfcomponent>