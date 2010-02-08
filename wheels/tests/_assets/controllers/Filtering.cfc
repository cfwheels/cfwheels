<cfcomponent extends="Controller">

	<cffunction name="init">
		<cfset aStr.testArg1 = 1>
		<cfset aStr.testArg2 = 2>
		<cfset filters(through="dir", testArg=1, except="doNotRun")>
		<cfset filters(through="str", strArguments=Duplicate(aStr))>
		<cfset filters(through="both", bothArguments=Duplicate(aStr), testArg=1)>
		<cfset filters(through="pub,priv", only="index,actOne,actTwo")>
	</cffunction>

	<cffunction name="dir">
		<cfset request.filterTests.dirTest = arguments.testArg>
	</cffunction>

	<cffunction name="str">
		<cfset request.filterTests.strTest = StructCount(arguments) & arguments.testArg1>
	</cffunction>

	<cffunction name="both">
		<cfset request.filterTests.bothTest = StructCount(arguments) & arguments.testArg>
		<cfif NOT IsDefined("request.filterTests.test") OR request.filterTests.test IS "bothpubpriv">
			<cfset request.filterTests.test = "">
		</cfif>
		<cfset request.filterTests.test = request.filterTests.test & "both">
	</cffunction>

	<cffunction name="pub">
		<cfset request.filterTests.pubTest = true>
		<cfif NOT IsDefined("request.filterTests.test") OR request.filterTests.test IS "bothpubpriv">
			<cfset request.filterTests.test = "">
		</cfif>
		<cfset request.filterTests.test = request.filterTests.test & "pub">
		<cfset request.filterTests.pubTest = true>
	</cffunction>

	<cffunction name="priv" access="private">
		<cfset request.filterTests.privTest = true>
		<cfif NOT IsDefined("request.filterTests.test") OR request.filterTests.test IS "bothpubpriv">
			<cfset request.filterTests.test = "">
		</cfif>
		<cfset request.filterTests.test = request.filterTests.test & "priv">
	</cffunction>

</cfcomponent>