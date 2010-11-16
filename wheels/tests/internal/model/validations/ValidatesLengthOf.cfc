<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset variables.args = {property="lastName", message="[property] is the wrong length", exactly=0, maximum=0, minimum=0, within=""}>
		<cfset variables.object = model("user").new()>
	</cffunction>

	<cffunction name="test_Maximum_good">
		<cfset variables.object.lastName = "LessThan">
		<cfset variables.object.$validatesLengthOf(argumentCollection=variables.args, maximum=10)>
		<cfset assert("!variables.object.hasErrors()")>
	</cffunction>
	<cffunction name="test_Maximum_bad">
		<cfset variables.object.lastName = "SomethingMoreThanTenLetters">
		<cfset variables.object.$validatesLengthOf(argumentCollection=variables.args, maximum=10)>
		<cfset assert("variables.object.hasErrors()")>
	</cffunction>
	
	<cffunction name="test_Minimum_good">
		<cfset variables.object.lastName = "SomethingMoreThanTenLetters">
		<cfset variables.object.$validatesLengthOf(argumentCollection=variables.args, minimum=10)>
		<cfset assert("!variables.object.hasErrors()")>
	</cffunction>
	<cffunction name="test_Minimum_bad">
		<cfset variables.object.lastName = "LessThan">
		<cfset variables.object.$validatesLengthOf(argumentCollection=variables.args, minimum=10)>
		<cfset assert("variables.object.hasErrors()")>
	</cffunction>

	<cffunction name="test_Within_good">
		<cfset variables.object.lastName = "6Chars">
		<cfset loc.within = [4,8]>
		<cfset variables.object.$validatesLengthOf(argumentCollection=variables.args, within=loc.within)>
		<cfset assert("!variables.object.hasErrors()")>
	</cffunction>
	<cffunction name="test_Within_bad">
		<cfset variables.object.lastName = "6Chars">
 		<cfset loc.within = [2,5]>
		<cfset variables.object.$validatesLengthOf(argumentCollection=variables.args, within=loc.within)>
		<cfset assert("variables.object.hasErrors()")>
	</cffunction>

	<cffunction name="test_Exactly_good">
		<cfset variables.object.lastName = "Exactly14Chars">
		<cfset variables.object.$validatesLengthOf(argumentCollection=variables.args, exactly=14)>
		<cfset assert("!variables.object.hasErrors()")>
	</cffunction>
	<cffunction name="test_Exactly_bad">
		<cfset variables.object.lastName = "Exactly14Chars">
		<cfset variables.object.$validatesLengthOf(argumentCollection=variables.args, exactly=99)>
		<cfset assert("variables.object.hasErrors()")>
	</cffunction>

</cfcomponent>