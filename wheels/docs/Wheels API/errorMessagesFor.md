# errorMessagesFor()

## Description
Builds and returns a list (`ul` tag with a default class of `errorMessages`) containing all the error messages for all the properties of the object (if any). Returns an empty string otherwise.

## Function Syntax
	errorMessagesFor( objectName, [ class, showDuplicates ] )


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
			<td>The variable name of the object to display error messages for.</td>
		</tr>
		
		<tr>
			<td>class</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>CSS class to set on the `ul` element.</td>
		</tr>
		
		<tr>
			<td>showDuplicates</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Whether or not to show duplicate error messages.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- view code --->
		<cfoutput>
		    #errorMessagesFor(objectName="user")#
		</cfoutput>
