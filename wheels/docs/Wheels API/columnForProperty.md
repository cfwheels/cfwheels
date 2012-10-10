# columnForProperty()

## Description
Returns the column name mapped for the named model property.

## Function Syntax
	columnForProperty( property )


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
		<cfset employee.columnForProperty("firstName")><!--- returns column name, in this case "firstname" if the convention is used --->
