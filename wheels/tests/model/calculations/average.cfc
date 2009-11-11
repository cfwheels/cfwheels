<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<cffunction name="test_average_with_integer">
		<cfset loc.result = model("post").average(property="views")>
		<cfset assert("loc.result IS 3.25")>
	</cffunction>

	<cffunction name="test_average_with_float">
		<cfset loc.result = model("post").average(property="averageRating")>
		<cfset assert("loc.result IS 3.4")>
	</cffunction>

	<cffunction name="test_average_with_non_matching_where">
		<cfset loc.result = model("post").average(property="averageRating", where="id=0")>
		<cfset assert("loc.result IS ''")>
	</cffunction>

</cfcomponent>