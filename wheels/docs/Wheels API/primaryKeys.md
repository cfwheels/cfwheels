# primaryKeys()

## Description
Alias for @primaryKey. Use this for better readability when you're accessing multiple primary keys.

## Function Syntax
	primaryKeys( [ position ] )


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
			<td>position</td>
			<td>numeric</td>
			<td>false</td>
			<td>0</td>
			<td>If you are accessing a composite primary key, pass the position of a single key to fetch.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Get a list of the names of the primary keys in the table mapped to the `employee` model (which is the `employees` table by default) --->
		<cfset keyNames = model("employee").primaryKeys()>
