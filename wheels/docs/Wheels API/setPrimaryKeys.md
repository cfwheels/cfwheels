# setPrimaryKeys()

## Description
Alias for @setPrimaryKey. Use this for better readability when you're setting multiple properties as the primary key.

## Function Syntax
	setPrimaryKeys( property )


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
			<td>Property (or list of properties) to set as the primary key.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- In `models/Subscription.cfc`, define the primary key as composite of the columns `customerId` and `publicationId` --->
		<cffunction name="init">
			<cfset setPrimaryKeys("customerId,publicationId")>
		</cffunction>
