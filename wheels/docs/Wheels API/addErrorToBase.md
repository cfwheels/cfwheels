# addErrorToBase()

## Description
Adds an error on the object as a whole (not related to any specific property).

## Function Syntax
	addErrorToBase( message, [ name ] )


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
			<td>message</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>The error message (such as "Please enter a correct name in the form field" for example).</td>
		</tr>
		
		<tr>
			<td>name</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>A name to identify the error by (useful when you need to distinguish one error from another one set on the same object and you don't want to use the error message itself for that).</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Add an error on the object --->
		<cfset this.addErrorToBase(message="Your email address must be the same as your domain name.")>
