<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_boolean_handled_properly">
		<cfset loc.sqltype = model("Sqltype").findOne()>
		<cfset loc.sqltype.booleanType = "false">
		<cfset $assert('!loc.sqltype.hasChanged("booleanType")')>
 		<cfset loc.sqltype.booleanType = "no">
		<cfset $assert('!loc.sqltype.hasChanged("booleanType")')>
 		<cfset loc.sqltype.booleanType = 0>
		<cfset $assert('!loc.sqltype.hasChanged("booleanType")')>
 		<cfset loc.sqltype.booleanType = "0">
		<cfset $assert('!loc.sqltype.hasChanged("booleanType")')>
		<cfset loc.sqltype.booleanType = "true">
		<cfset $assert('loc.sqltype.hasChanged("booleanType")')>
 		<cfset loc.sqltype.booleanType = "yes">
		<cfset $assert('loc.sqltype.hasChanged("booleanType")')>
 		<cfset loc.sqltype.booleanType = 1>
		<cfset $assert('loc.sqltype.hasChanged("booleanType")')>
 		<cfset loc.sqltype.booleanType = "1">
		<cfset $assert('loc.sqltype.hasChanged("booleanType")')>
	</cffunction>
	
</cfcomponent>