<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset variables.args = {$test=true, property="lastName", message="[property] is the wrong length", exactly=0, maximum=0, minimum=0, within="", returnAs="string"}>
		<cfset variables.object = model("user").new()>
	</cffunction>

	<cffunction name="testMaximum">
		<cfset variables.object.lastName = "SomethingMoreThanTenLetters">
		<cfset loc.result = variables.object.$validatesLengthOf(argumentCollection=variables.args, maximum=10)>
		<cfset assert("!StructIsEmpty(loc.result)")>
		<cfset variables.object.lastName = "LessThan">
		<cfset loc.result = variables.object.$validatesLengthOf(argumentCollection=variables.args, maximum=10)>
		<cfset assert("StructIsEmpty(loc.result)")>
	</cffunction>

	<cffunction name="testMinimum">
		<cfset variables.object.lastName = "SomethingMoreThanTenLetters">
		<cfset loc.result = variables.object.$validatesLengthOf(argumentCollection=variables.args, minimum=10)>
		<cfset assert("StructIsEmpty(loc.result)")>
		<cfset variables.object.lastName = "LessThan">
		<cfset loc.result = variables.object.$validatesLengthOf(argumentCollection=variables.args, minimum=10)>
		<cfset assert("!StructIsEmpty(loc.result)")>
	</cffunction>

	<cffunction name="testWithin">
		<cfset variables.object.lastName = "6Chars">
		<cfset loc.within = [4,8]>
		<cfset loc.result = variables.object.$validatesLengthOf(argumentCollection=variables.args, within=loc.within)>
		<cfset assert("StructIsEmpty(loc.result)")>
		<cfset loc.within = [2,5]>
		<cfset loc.result = variables.object.$validatesLengthOf(argumentCollection=variables.args, within=loc.within)>
		<cfset assert("!StructIsEmpty(loc.result)")>
	</cffunction>

	<cffunction name="testExactly">
		<cfset variables.object.lastName = "Exactly14Chars">
		<cfset loc.result = variables.object.$validatesLengthOf(argumentCollection=variables.args, exactly=14)>
		<cfset assert("StructIsEmpty(loc.result)")>
		<cfset loc.result = variables.object.$validatesLengthOf(argumentCollection=variables.args, exactly=99)>
		<cfset assert("!StructIsEmpty(loc.result)")>
	</cffunction>

</cfcomponent>