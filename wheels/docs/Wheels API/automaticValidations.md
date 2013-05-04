# automaticValidations()

## Description
Whether or not to enable default validations for this model.

## Function Syntax
	automaticValidations( value )


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
			<td>value</td>
			<td>boolean</td>
			<td>true</td>
			<td></td>
			<td></td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- In `models/User.cfc`, disable automatic validations. In this case, automatic validations are probably enabled globally, but we want to disable just for this model --->
		<cffunction name="init">
			<cfset automaticValidations(false)>
		</cffunction>
