# updateProperties()

## Description
Updates all the properties from the `properties` argument or other named arguments. If the object is invalid, the save will fail and `false` will be returned.

## Function Syntax
	updateProperties( [ properties, parameterize, validate, transaction, callbacks ] )


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
			<td>Struct containing key/value pairs with properties and associated values that need to be updated globally.</td>
		</tr>
		
		<tr>
			<td>parameterize</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to use `cfqueryparam` on all columns, or pass in a list of property names to use `cfqueryparam` on those only.</td>
		</tr>
		
		<tr>
			<td>validate</td>
			<td>boolean</td>
			<td>false</td>
			<td>true</td>
			<td>Set to `false` to skip validations for this operation.</td>
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
	
		<!--- Sets the `new` property to `1` through `updateProperties()` --->
		<cfset product = model("product").findByKey(56)>
		<cfset product.updateProperties(new=1)>
