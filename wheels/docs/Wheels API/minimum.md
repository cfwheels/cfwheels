# minimum()

## Description
Calculates the minimum value for a given property. Uses the SQL function `MIN`. If no records can be found to perform the calculation on you can use the `ifNull` argument to decide what should be returned.

## Function Syntax
	minimum( property, [ where, include, parameterize, ifNull, includeSoftDeletes, reload ] )


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
			<td>Name of the property to get the lowest value for (must be a property of a numeric data type).</td>
		</tr>
		
		<tr>
			<td>where</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>This argument maps to the `WHERE` clause of the query. The following operators are supported: `=`, `!=`, `<>`, `<`, `<=`, `>`, `>=`, `LIKE`, `NOT LIKE`, `IN`, `NOT IN`, `IS NULL`, `IS NOT NULL`, `AND`, and `OR`. (Note that the key words need to be written in upper case.) You can also use parentheses to group statements. You do not need to specify the table name(s); Wheels will do that for you.</td>
		</tr>
		
		<tr>
			<td>include</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Associations that should be included in the query using `INNER` or `LEFT OUTER` joins (which join type that is used depends on how the association has been set up in your model). If all included associations are set on the current model, you can specify them in a list (e.g. `department,addresses,emails`). You can build more complex `include` strings by using parentheses when the association is set on an included model, like `album(artist(genre))`, for example. These complex `include` strings only work when `returnAs` is set to `query` though.</td>
		</tr>
		
		<tr>
			<td>parameterize</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to use `cfqueryparam` on all columns, or pass in a list of property names to use `cfqueryparam` on those only.</td>
		</tr>
		
		<tr>
			<td>ifNull</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>The value returned if no records are found. Common usage is to set this to `0` to make sure a numeric value is always returned instead of a blank string.</td>
		</tr>
		
		<tr>
			<td>includeSoftDeletes</td>
			<td>boolean</td>
			<td>false</td>
			<td>false</td>
			<td>You can set this argument to `true` to include soft-deleted records in the results.</td>
		</tr>
		
		<tr>
			<td>reload</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to reload the object from the database once an insert/update has completed.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Get the amount of the lowest salary for all employees --->
		<cfset lowestSalary = model("employee").minimum("salary")>
		
		<!--- Get the amount of the lowest salary for employees in a given department --->
		<cfset lowestSalary = model("employee").minimum(property="salary", where="departmentId=#params.key#")>
		
		<!--- Make sure a numeric amount is always returned, even when there were no records analyzed by the query --->
		<cfset lowestSalary = model("employee").minimum(property="salary", where="salary BETWEEN #params.min# AND #params.max#", ifNull=0)>
