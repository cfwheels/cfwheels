# changedFrom()

## Description
Returns the previous value of a property that has changed. Returns an empty string if no previous value exists. Wheels will keep a note of the previous property value until the object is saved to the database.

## Function Syntax
	changedFrom( property )


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
			<td>true</td>
			<td></td>
			<td>Name of property to get the previous value for.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Get a member object and change the `email` property on it --->
		<cfset member = model("member").findByKey(params.memberId)>
		<cfset member.email = params.newEmail>

		<!--- Get the previous value (what the `email` property was before it was changed)--->
		<cfset oldValue = member.changedFrom("email")>

		<!--- The above can also be done using a dynamic function like this --->
		<cfset oldValue = member.emailChangedFrom()>
