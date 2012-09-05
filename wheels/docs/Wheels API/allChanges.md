# allChanges()

## Description
Returns a struct detailing all changes that have been made on the object but not yet saved to the database.

## Function Syntax
	allChanges(  )



## Examples
	
		<!--- Get an object, change it, and then ask for its changes (will return a struct containing the changes, both property names and their values) --->
		<cfset member = model("member").findByKey(params.memberId)>
		<cfset member.firstName = params.newFirstName>
		<cfset member.email = params.newEmail>
		<cfset allChanges = member.allChanges()>
