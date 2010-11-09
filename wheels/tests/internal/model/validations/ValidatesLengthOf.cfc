<cfcomponent extends="wheelsMapping.Test">

	<cfset variables.args = {$test=true, property="lastName", message="[property] is the wrong length", exactly=0, maximum=0, minimum=0, within=""}>

	<cffunction name="setup">
		<cfset StructDelete(variables, "result")>
		<cfset variables.object = model("user").new()>
	</cffunction>

	<cffunction name="testMaximum">
		<cfset variables.object.lastName = "SomethingMoreThanTenLetters">
		<cfset result = variables.object.$validatesLengthOf(argumentCollection=variables.args, maximum=10)>
		<cfset assert("!StructIsEmpty(result)")>
		<cfset variables.object.lastName = "LessThan">
		<cfset result = variables.object.$validatesLengthOf(argumentCollection=variables.args, maximum=10)>
		<cfset assert("StructIsEmpty(result)")>
	</cffunction>

	<cffunction name="testMinimum">
		<cfset variables.object.lastName = "SomethingMoreThanTenLetters">
		<cfset result = variables.object.$validatesLengthOf(argumentCollection=variables.args, minimum=10)>
		<cfset assert("StructIsEmpty(result)")>
		<cfset variables.object.lastName = "LessThan">
		<cfset result = variables.object.$validatesLengthOf(argumentCollection=variables.args, minimum=10)>
		<cfset assert("!StructIsEmpty(result)")>
	</cffunction>

	<cffunction name="testWithin">
		<cfset var loc = {}>
		<cfset variables.object.lastName = "6Chars">
		<cfset loc.within = [4,8]>
		<cfset result = variables.object.$validatesLengthOf(argumentCollection=variables.args, within=loc.within)>
		<cfset assert("StructIsEmpty(result)")>
		<cfset loc.within = [2,5]>
		<cfset result = variables.object.$validatesLengthOf(argumentCollection=variables.args, within=loc.within)>
		<cfset assert("!StructIsEmpty(result)")>
	</cffunction>

	<cffunction name="testExactly">
		<cfset variables.object.lastName = "Exactly14Chars">
		<cfset result = variables.object.$validatesLengthOf(argumentCollection=variables.args, exactly=14)>
		<cfset assert("StructIsEmpty(result)")>
		<cfset result = variables.object.$validatesLengthOf(argumentCollection=variables.args, exactly=99)>
		<cfset assert("!StructIsEmpty(result)")>
	</cffunction>

</cfcomponent>