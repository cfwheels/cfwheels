<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_minimum">
		<cfset loc.result = model("post").minimum(property="views")>
		<cfset assert("loc.result IS 0")>
	</cffunction>

	<cffunction name="test_minimum_with_non_matching_where">
		<cfset loc.result = model("post").minimum(property="views", where="id=0")>
		<cfset assert("loc.result IS ''")>
	</cffunction>

	<cffunction name="test_minimum_with_ifNull">
		<cfset loc.result = model("post").minimum(property="views", where="id=0", ifNull=0)>
		<cfset assert("loc.result IS 0")>
	</cffunction>

</cfcomponent>