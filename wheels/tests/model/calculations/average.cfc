<cfcomponent extends="wheelsMapping.Test">

	<!--- integers --->

	<cffunction name="test_average_with_integer">
		<cfset loc.result = model("post").average(property="views")>
		<cfset assert("loc.result IS 3")>
	</cffunction>

	<cffunction name="test_average_with_integer_with_non_matching_where">
		<cfset loc.result = model("post").average(property="views", where="id=0")>
		<cfset assert("loc.result IS ''")>
	</cffunction>

	<cffunction name="test_average_with_integer_with_distinct">
		<cfset loc.result = model("post").average(property="views", distinct="true")>
		<cfset assert("DecimalFormat(loc.result) IS DecimalFormat(2.50)")>
	</cffunction>

	<cffunction name="test_average_with_integer_with_ifNull">
		<cfset loc.result = model("post").average(property="views", where="id=0", ifNull=0)>
		<cfset assert("loc.result IS 0")>
	</cffunction>	

	<!--- floats --->

	<cffunction name="test_average_with_float">
		<cfset loc.result = model("post").average(property="averageRating")>
		<cfset assert("DecimalFormat(loc.result) IS DecimalFormat(3.50)")>
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
	
	<!--- include deleted records --->
	
	<cffunction name="test_average_with_include_soft_deletes">
		<cftransaction action="begin">
			<cfset loc.post = model("Post").findOne(where="views=0")>
			<cfset loc.post.delete(transaction="none")>
			<cfset loc.average = model("Post").average(property="views", includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.average eq 3')>
	</cffunction>

</cfcomponent>