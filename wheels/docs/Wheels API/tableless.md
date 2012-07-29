# tableless()

## Description
allows this model to be used without a database

## Function Syntax
	tableless(  )



## Examples
	
		<!--- In models/User.cfc --->
		<cffunction name="init">
			<!--- Tells wheels to not to use a database for this model --->
  			<cfset tableless()>
		</cffunction>
