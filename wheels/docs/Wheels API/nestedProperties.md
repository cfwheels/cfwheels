# nestedProperties()

## Description
Allows for nested objects, structs, and arrays to be set from params and other generated data.

## Function Syntax
	nestedProperties( [ association, autoSave, allowDelete, sortProperty, rejectIfBlank ] )


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
			<td>association</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The association (or list of associations) you want to allow to be set through the params. This argument is also aliased as `associations`.</td>
		</tr>
		
		<tr>
			<td>autoSave</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Whether to save the association(s) when the parent object is saved.</td>
		</tr>
		
		<tr>
			<td>allowDelete</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Set `allowDelete` to `true` to tell Wheels to look for the property `_delete` in your model. If present and set to a value that evaluates to `true`, the model will be deleted when saving the parent.</td>
		</tr>
		
		<tr>
			<td>sortProperty</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Set `sortProperty` to a property on the object that you would like to sort by. The property should be numeric, should start with 1, and should be consecutive. Only valid with `hasMany` associations.</td>
		</tr>
		
		<tr>
			<td>rejectIfBlank</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>A list of properties that should not be blank. If any of the properties are blank, any CRUD operations will be rejected.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- In `models/User.cfc`, allow for `groupEntitlements` to be saved and deleted through the `user` object --->
		<cffunction name="init">
			<cfset hasMany("groupEntitlements")>
			<cfset nestedProperties(association="groupEntitlements", allowDelete=true)>
		</cffunction>
