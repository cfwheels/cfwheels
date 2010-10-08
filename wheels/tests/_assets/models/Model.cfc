<cfcomponent extends="wheelsMapping.Model">

	<cffunction name="oracleAutoInc">
		<cfset var loc = {}>
		<cfset loc.priKey = primaryKeys(1)>
		<cfif variables.wheels.class.connInfo.adapterName eq "Oracle" AND !StructKeyExists(this, loc.priKey)>
			<cfset loc.args = {}>
			<cfset loc.args.name = "loc.sequence">
			<cfset structappend(loc.args, variables.wheels.class.connection)>
			<cfquery attributeCollection="#loc.args#">
			SELECT #tableName()#_seq.nextval AS newId FROM dual
			</cfquery>
			<cfset this[loc.priKey] = loc.sequence.newId>
		</cfif>
    </cffunction>

</cfcomponent>