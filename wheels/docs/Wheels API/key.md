# key()

## Description
Returns the value of the primary key for the object. If you have a single primary key named `id`, then `someObject.key()` is functionally equivalent to `someObject.id`. This method is more useful when you do dynamic programming and don't know the name of the primary key or when you use composite keys (in which case it's convenient to use this method to get a list of both key values returned).

## Function Syntax
	key(  )



## Examples
	
		<!--- Get an object and then get the primary key value(s) --->
		<cfset employee = model("employee").findByKey(params.key)>
		<cfset val = employee.key()>
