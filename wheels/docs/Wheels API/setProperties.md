# setProperties()

## Description
Allows you to set all the properties of an object at once by passing in a structure with keys matching the property names.

## Function Syntax
	setProperties( [ properties ] )


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
			<td>properties</td>
			<td>struct</td>
			<td>false</td>
			<td>[runtime expression]</td>
			<td>The properties you want to set on the object (can also be passed in as named arguments).</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Update the properties of the object with the params struct containing the values of a form post --->
		<cfset user = model("user").findByKey(1)>
		<cfset user.setProperties(params.user)>
