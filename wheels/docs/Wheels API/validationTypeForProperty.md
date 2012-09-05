# validationTypeForProperty()

## Description
Returns the validation type for the property

## Function Syntax
	validationTypeForProperty( property )


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
			<td>Name of column to retrieve data for.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- first name is a varchar(50) column --->
		<cfset employee = model("employee").new()>
		<!--- would output "string" --->
		<cfoutput>#employee.validationTypeForProperty("firstName")>#</cfoutput>
