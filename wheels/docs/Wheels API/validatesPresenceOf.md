# validatesPresenceOf()

## Description
Validates that the specified property exists and that its value is not blank.

## Function Syntax
	validatesPresenceOf( properties, [ message, when, condition, unless ] )


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
	
		<!--- Make sure that the user data can not be saved to the database without the `emailAddress` property. (It must exist and not be an empty string) --->
		<cfset validatesPresenceOf("emailAddress")>
		
		<!--- Basic use of condition --->
		<cfset validatesPresenceOf(properties="userid")>
		
		<cfset validatesPresenceOf(properties="email", condition="isDefined('this.userid')")>
		<cfset validatesPresenceOf(properties="email", condition="isDefined('this.userid') AND isNumeric(this.userid)")>
		
		<cfset validatesPresenceOf(properties="email", condition="StructKeyExists(this, 'userid')")>
		<cfset validatesPresenceOf(properties="email", condition="StructKeyExists(this, 'userid') AND isNumeric(this.userid)")>
