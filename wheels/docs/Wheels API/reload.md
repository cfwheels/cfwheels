# reload()

## Description
Reloads the property values of this object from the database.

## Function Syntax
	reload(  )



## Examples
	
		<!--- Get an object, call a method on it that could potentially change values, and then reload the values from the database --->
		<cfset employee = model("employee").findByKey(params.key)>
		<cfset employee.someCallThatChangesValuesInTheDatabase()>
		<cfset employee.reload()>
