# tableName()

## Description
Returns the name of the database table that this model is mapped to.

## Function Syntax
	tableName(  )



## Examples
	
		<!--- Check what table the user model uses --->
		<cfset whatAmIMappedTo = model("user").tableName()>
