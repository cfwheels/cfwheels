# updateProperty()

## Description
Updates a single property and saves the record without going through the normal validation procedure. This is especially useful for boolean flags on existing records.

## Function Syntax
	updateProperty( property, value, [ parameterize, transaction, callbacks ] )


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
			<td>Name of the property to update the value for globally.</td>
		</tr>
		
		<tr>
			<td>value</td>
			<td>any</td>
			<td>true</td>
			<td></td>
			<td>Value to set on the given property globally.</td>
		</tr>
		
		<tr>
			<td>parameterize</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to use `cfqueryparam` on all columns, or pass in a list of property names to use `cfqueryparam` on those only.</td>
		</tr>
		
		<tr>
			<td>transaction</td>
			<td>string</td>
			<td>false</td>
			<td>[runtime expression]</td>
			<td>Set this to `commit` to update the database when the save has completed, `rollback` to run all the database queries but not commit them, or `none` to skip transaction handling altogether.</td>
		</tr>
		
		<tr>
			<td>callbacks</td>
			<td>boolean</td>
			<td>false</td>
			<td>true</td>
			<td>Set to `false` to disable callbacks for this operation.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Sets the `new` property to `1` through updateProperty() --->
		<cfset product = model("product").findByKey(56)>
		<cfset product.updateProperty("new", 1)>
