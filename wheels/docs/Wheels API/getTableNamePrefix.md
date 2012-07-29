# getTableNamePrefix()

## Description
Returns the table name prefix set for the table.

## Function Syntax
	getTableNamePrefix(  )



## Examples
	
		<!--- Get the table name prefix for this user when running a custom query --->
		<cffunction name="getDisabledUsers" returntype="query">
			<cfset var loc = {}>
			<cfquery datasource="#get('dataSourceName')#" name="loc.disabledUsers">
				SELECT
					*
				FROM
					#this.getTableNamePrefix()#users
				WHERE
					disabled = 1
			</cfquery>
			<cfreturn loc.disabledUsers>
		</cffunction>
