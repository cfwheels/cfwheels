# errorsOn()

## Description
Returns an array of all errors associated with the supplied property (and error name if passed in).

## Function Syntax
	errorsOn( property, [ name ] )


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
			<td>Specify the property name to return errors for here.</td>
		</tr>
		
		<tr>
			<td>name</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>If you want to return only errors on the above property set with a specific error name you can specify it here.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Get all errors related to the email address of the user object --->
		<cfset errors = user.errorsOn("emailAddress")>
