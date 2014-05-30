# validatesConfirmationOf()

## Description
Validates that the value of the specified property also has an identical confirmation value. (This is common when having a user type in their email address a second time to confirm, confirming a password by typing it a second time, etc.) The confirmation value only exists temporarily and never gets saved to the database. By convention, the confirmation property has to be named the same as the property with "Confirmation" appended at the end. Using the password example, to confirm our `password` property, we would create a property called `passwordConfirmation`.

## Function Syntax
	validatesConfirmationOf( properties, [ message, when, condition, unless ] )


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
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Name of property or list of property names to validate against (can also be called with the `property` argument).</td>
		</tr>
		
		<tr>
			<td>message</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Supply a custom error message here to override the built-in one.</td>
		</tr>
		
		<tr>
			<td>when</td>
			<td>string</td>
			<td>false</td>
			<td>onSave</td>
			<td>Pass in `onCreate` or `onUpdate` to limit when this validation occurs (by default validation will occur on both create and update, i.e. `onSave`).</td>
		</tr>
		
		<tr>
			<td>condition</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String expression to be evaluated that decides if validation will be run (if the expression returns `true` validation will run).</td>
		</tr>
		
		<tr>
			<td>unless</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String expression to be evaluated that decides if validation will be run (if the expression returns `false` validation will run).</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Make sure that the user has to confirm their password correctly the first time they register (usually done by typing it again in a second form field) --->
		<cfset validatesConfirmationOf(property="password", when="onCreate", message="Your password and its confirmation do not match. Please try again.")>
