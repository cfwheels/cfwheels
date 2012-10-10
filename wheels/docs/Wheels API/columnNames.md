# columnNames()

## Description
Returns a list of column names in the table mapped to this model. The list is ordered according to the columns' ordinal positions in the database table.

## Function Syntax
	columnNames(  )



## Examples
	
		<!--- Get a list of all the column names in the table mapped to the `author` model --->
		<cfset columns = model("author").columnNames()>
