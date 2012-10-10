# includedInObject()

## Description
Used as a shortcut to check if the specified IDs are a part of the main form object. This method should only be used for `hasMany` associations.

## Function Syntax
	includedInObject( objectName, association, keys )


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
			<td>objectName</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Name of the variable containing the parent object to represent with this form field.</td>
		</tr>
		
		<tr>
			<td>association</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Name of the association set in the parent object to represent with this form field.</td>
		</tr>
		
		<tr>
			<td>keys</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Primary keys associated with this form field. Note that these keys should be listed in the order that they appear in the database table.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Check to see if the customer is subscribed to the Swimsuit Edition. Note that the order of the `keys` argument should match the order of the `customerid` and `publicationid` columns in the `subscriptions` join table --->
		<cfif not includedInObject(objectName="customer", association="subscriptions", keys="#customer.key()#,#swimsuitEdition.id#")>
			<cfset assignSalesman(customer)>
		</cfif>
