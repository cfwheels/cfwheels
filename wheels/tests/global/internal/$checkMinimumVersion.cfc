<cfcomponent extends="wheelsMapping.Test">

	<cfset railoVersion = "3.1.2.020">
	<cfset adobeVersion = "8,0,1,0">

	<cffunction name="test_railo_valid">
		<cfset assert('$checkMinimumVersion("3.1.2.020", railoVersion)')>
		<cfset assert('$checkMinimumVersion("3.2.2.020", railoVersion)')>
		<cfset assert('$checkMinimumVersion("3.1.2.022", railoVersion)')>
		<cfset assert('$checkMinimumVersion("4.0.0.0", railoVersion)')>
	</cffunction>

	<cffunction name="test_railo_invalid">
		<cfset assert('!$checkMinimumVersion("3.1.2.018", railoVersion)')>
		<cfset assert('!$checkMinimumVersion("3.1.2.019", railoVersion)')>
		<cfset assert('!$checkMinimumVersion("3", railoVersion)')>
		<cfset assert('!$checkMinimumVersion("2.1.2.3", railoVersion)')>
	</cffunction>

	<cffunction name="test_adobe_valid">
		<cfset assert('$checkMinimumVersion("8,0,1,0", adobeVersion)')>
		<cfset assert('$checkMinimumVersion("9,0,0,251028", adobeVersion)')>
		<cfset assert('$checkMinimumVersion("8,0,1,195765", adobeVersion)')>
		<cfset assert('$checkMinimumVersion("10,0,0,277803", adobeVersion)')>
	</cffunction>

	<cffunction name="test_adobe_invalid">
		<cfset assert('!$checkMinimumVersion("8,0", adobeVersion)')>
		<cfset assert('!$checkMinimumVersion("8,0,0,0", adobeVersion)')>
		<cfset assert('!$checkMinimumVersion("8,0,0,195765", adobeVersion)')>
		<cfset assert('!$checkMinimumVersion("7", adobeVersion)')>
	</cffunction>

</cfcomponent>