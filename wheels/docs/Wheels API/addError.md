# addError()

## Description
Adds an error on a specific property.

## Function Syntax
	addError( property, message, [ name ] )


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
			<td>The name of the property you want to add an error on.</td>
		</tr>
		
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
	
		<!--- Add an error to the `email` property --->
		<cfset this.addError(property="email", message="Sorry, you are not allowed to use that email. Try again, please.")>
