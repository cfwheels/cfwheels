# changedProperties()

## Description
Returns a list of the object properties that have been changed but not yet saved to the database.

## Function Syntax
	changedProperties(  )



## Examples
	
		<!--- Get an object, change it, and then ask for its changes (will return a list of the property names that have changed, not the values themselves) --->
		<cfset member = model("member").findByKey(params.memberId)>
		<cfset member.firstName = params.newFirstName>
		<cfset member.email = params.newEmail>
		<cfset changedProperties = member.changedProperties()>
