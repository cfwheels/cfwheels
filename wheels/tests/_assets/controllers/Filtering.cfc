<cfcomponent extends="Controller">

	<cffunction name="init">
		<cfset aStr.testArg1 = 1>
		<cfset aStr.testArg2 = 2>
		<cfset filters(through="dir", testArg=1)>
		<cfset filters(through="str", strArguments=Duplicate(aStr))>
		<cfset filters(through="both", bothArguments=Duplicate(aStr), testArg=1)>
		<cfset filters(through="pub,priv")>
	</cffunction>

	<cffunction name="dir">
		<cfset request.dirTest = arguments.testArg>
	</cffunction>

	<cffunction name="str">
		<cfset request.strTest = StructCount(arguments) & arguments.testArg1>
	</cffunction>

	<cffunction name="both">
		<cfset request.bothTest = StructCount(arguments) & arguments.testArg>
	</cffunction>

	<cffunction name="pub">
		<cfset request.pubTest = true>
	</cffunction>

	<cffunction name="priv" access="private">
		<cfset request.privTest = true>
	</cffunction>

</cfcomponent>