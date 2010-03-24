<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">

	<!--- integers --->

	<cffunction name="test_average_with_integer">
		<cfset loc.result = model("post").average(property="views")>
		<cfset assert("loc.result IS 3.25")>
	</cffunction>

	<cffunction name="test_average_with_integer_with_non_matching_where">
		<cfset loc.result = model("post").average(property="views", where="id=0")>
		<cfset assert("loc.result IS ''")>
	</cffunction>

	<cffunction name="test_average_with_integer_with_distinct">
		<cfset loc.result = model("post").average(property="views", distinct="true")>
		<cfset assert("DecimalFormat(loc.result) IS DecimalFormat(2.66666666667)")>
	</cffunction>

	<cffunction name="test_average_with_integer_with_ifNull">
		<cfset loc.result = model("post").average(property="views", where="id=0", ifNull=0)>
		<cfset assert("loc.result IS 0")>
	</cffunction>	

	<!--- floats --->

	<cffunction name="test_average_with_float">
		<cfset loc.result = model("post").average(property="averageRating")>
		<cfset assert("DecimalFormat(loc.result) IS DecimalFormat(3.47)")>
	</cffunction>

	<cffunction name="test_average_with_float_with_non_matching_where">
		<cfset loc.result = model("post").average(property="averageRating", where="id=0")>
		<cfset assert("loc.result IS ''")>
	</cffunction>

	<cffunction name="test_average_with_float_with_distinct">
		<cfset loc.result = model("post").average(property="averageRating", distinct="true")>
		<cfset assert("DecimalFormat(loc.result) IS DecimalFormat(3.4)")>
	</cffunction>

	<cffunction name="test_average_with_float_with_ifNull">
		<cfset loc.result = model("post").average(property="averageRating", where="id=0", ifNull=0)>
		<cfset assert("loc.result IS 0")>
	</cffunction>	

</cfcomponent>