<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_boolean_handled_properly">
		<cfset loc.sqltype = model("Sqltype").findOne()>
		<cfset loc.sqltype.booleanType = "false">
		<cfset assert(!loc.sqltype.hasChanged("booleanType"))>
 		<cfset loc.sqltype.booleanType = "no">
		<cfset assert(!loc.sqltype.hasChanged("booleanType"))>
 		<cfset loc.sqltype.booleanType = 0>
		<cfset assert(!loc.sqltype.hasChanged("booleanType"))>
 		<cfset loc.sqltype.booleanType = "0">
		<cfset assert(!loc.sqltype.hasChanged("booleanType"))>
		<cfset loc.sqltype.booleanType = "true">
		<cfset assert(loc.sqltype.hasChanged("booleanType"))>
 		<cfset loc.sqltype.booleanType = "yes">
		<cfset assert(loc.sqltype.hasChanged("booleanType"))>
 		<cfset loc.sqltype.booleanType = 1>
		<cfset assert(loc.sqltype.hasChanged("booleanType"))>
 		<cfset loc.sqltype.booleanType = "1">
		<cfset assert(loc.sqltype.hasChanged("booleanType"))>
	</cffunction>

	<cffunction name="test_should_be_able_to_update_integer_from_null_to_0">
		<cfset loc.user = model("user").findByKey(1)>
		<cftransaction>
			<cfset loc.user.birthDayYear = "">
			<cfset loc.user.save()>
			<cfset loc.user.birthDayYear = 0>
			<cfset loc.user.save()>
			<cfset loc.user.reload()>
			<cftransaction action="rollback">
		</cftransaction>
		<cfset assert(loc.user.birthDayYear IS 0)>
	</cffunction>
	
</cfcomponent>