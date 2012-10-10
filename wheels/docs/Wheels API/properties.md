# properties()

## Description
Returns a structure of all the properties with their names as keys and the values of the property as values.

## Function Syntax
	properties(  )



## Examples
	
		<!--- Get a structure of all the properties for an object --->
		<cfset user = model("user").findByKey(1)>
		<cfset props = user.properties()>
