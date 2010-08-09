<cfcomponent extends="wheelsMapping.test">

	<cffunction name="test_1">
		<cfset loc.e = "address">
		<cfset loc.r = $singularizeOrPluralize("address","singularize")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_2">
		<cfset loc.e = "dress">
		<cfset loc.r = $singularizeOrPluralize("dress","singularize")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_3">
		<cfset loc.e = "dresses">
		<cfset loc.r = $singularizeOrPluralize("dress","pluralize")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

	<cffunction name="test_4">
		<cfset loc.e = "addresses">
		<cfset loc.r = $singularizeOrPluralize("address","pluralize")>
		<cfset assert('loc.e eq loc.r')>
	</cffunction>

</cfcomponent>