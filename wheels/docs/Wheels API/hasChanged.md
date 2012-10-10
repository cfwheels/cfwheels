# hasChanged()

## Description
Returns `true` if the specified property (or any if none was passed in) has been changed but not yet saved to the database. Will also return `true` if the object is new and no record for it exists in the database.

## Function Syntax
	hasChanged( [ property ] )


## Parameters
<table>
	<thead>
		<tr>
			<th>Parameter</th>
			<th>Type</th>
			<th>Required</th>
			<th>Default</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		
		<tr>
			<td>property</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Name of property to check for change.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Get a member object and change the `email` property on it --->
		<cfset member = model("member").findByKey(params.memberId)>
		<cfset member.email = params.newEmail>

		<!--- Check if the `email` property has changed --->
		<cfif member.hasChanged("email")>
			<!--- Do something... --->
		</cfif>

		<!--- The above can also be done using a dynamic function like this --->
		<cfif member.emailHasChanged()>
			<!--- Do something... --->
		</cfif>
