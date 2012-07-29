# isNew()

## Description
Returns `true` if this object hasn't been saved yet. (In other words, no matching record exists in the database yet.) Returns `false` if a record exists.

## Function Syntax
	isNew(  )



## Examples
	
		<!--- Create a new object and then check if it is new (yes, this example is ridiculous. It makes more sense in the context of callbacks for example) --->
		<cfset employee = model("employee").new()>
		<cfif employee.isNew()>
			<!--- Do something... --->
		</cfif>
