# hasProperty()

## Description
Returns `true` if the specified property name exists on the model.

## Function Syntax
	hasProperty( property )


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
			<td>Name of property to inspect.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Get an object, set a value and then see if the property exists --->
		<cfset employee = model("employee").new()>
		<cfset employee.firstName = "dude">
		<cfset employee.hasProperty("firstName")><!--- returns true --->

		<!--- This is also a dynamic method that you could do --->
		<cfset employee.hasFirstName()>
