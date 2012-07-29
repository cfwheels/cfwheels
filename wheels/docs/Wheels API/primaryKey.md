# primaryKey()

## Description
Returns the name of the primary key for this model's table. This is determined through database introspection. If composite primary keys have been used, they will both be returned in a list. This function is also aliased as `primaryKeys()`.

## Function Syntax
	primaryKey( [ position ] )


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
	
		<!--- Get the name of the primary key of the table mapped to the `employee` model (which is the `employees` table by default) --->
		<cfset keyName = model("employee").primaryKey()>
