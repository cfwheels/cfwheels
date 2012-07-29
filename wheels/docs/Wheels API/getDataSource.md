# getDataSource()

## Description
returns the connection (datasource) information for the model.

## Function Syntax
	getDataSource(  )



## Examples
	
		<!--- get the datasource information so we can write custom queries --->
		<cfquery name="q" datasource="#getDataSource().datasource#">
		select * from mytable
		</cfquery>
