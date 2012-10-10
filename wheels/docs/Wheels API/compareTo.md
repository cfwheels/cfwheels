# compareTo()

## Description
Pass in another Wheels model object to see if the two objects are the same.

## Function Syntax
	compareTo( object )


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
			<td>object</td>
			<td>component</td>
			<td>true</td>
			<td></td>
			<td></td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Load a user requested in the URL/form and restrict access if it doesn't match the user stored in the session --->
		<cfset user = model("user").findByKey(params.key)>
		<cfif not user.compareTo(session.user)>
			<cfset renderView(action="accessDenied")>
		</cfif>
