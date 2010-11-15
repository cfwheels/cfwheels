<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset loc.authorModel = model("author")>
	</cffunction>

	<cffunction name="test_set_order">
		<cfset loc.authorModel.order("id")>
		<cfset loc.orderData = loc.authorModel.toQuery().order[1]>
		<cfset assert('loc.orderData.property eq "id"')>
		<cfset assert('loc.orderData.direction eq "ASC"')>
	</cffunction>

	<cffunction name="test_set_order_multiple_times">
		<cfset loc.authorModel.order("id").order("authorid", "desc")>
		<cfset loc.order1Data = loc.authorModel.toQuery().order[1]>
		<cfset loc.order2Data = loc.authorModel.toQuery().order[2]>
		<cfset assert('loc.order1Data.property eq "id"')>
		<cfset assert('loc.order1Data.direction eq "ASC"')>
		<cfset assert('loc.order2Data.property eq "authorid"')>
		<cfset assert('loc.order2Data.direction eq "DESC"')>
	</cffunction>

</cfcomponent>