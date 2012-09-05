# columnDataForProperty()

## Description
Returns a struct with data for the named property.

## Function Syntax
	columnDataForProperty( property )


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
	
		<!--- Get an object, set a value and then see if the property exists --->
		<cfset employee = model("employee").new()>
		<cfset employee.columnDataForProperty("firstName")><!--- returns column struct --->
