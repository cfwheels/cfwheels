# validatesLengthOf()

## Description
Validates that the value of the specified property matches the length requirements supplied. Use the `exactly`, `maximum`, `minimum` and `within` arguments to specify the length requirements.

## Function Syntax
	validatesLengthOf( properties, [ message, when, allowBlank, exactly, maximum, minimum, within, condition, unless ] )


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
			<td>allowBlank</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>If set to `true`, validation will be skipped if the property value is an empty string or doesn't exist at all. This is useful if you only want to run this validation after it passes the @validatesPresenceOf test, thus avoiding duplicate error messages if it doesn't.</td>
		</tr>
		
		<tr>
			<td>exactly</td>
			<td>numeric</td>
			<td>false</td>
			<td></td>
			<td>The exact length that the property value must be.</td>
		</tr>
		
		<tr>
			<td>maximum</td>
			<td>numeric</td>
			<td>false</td>
			<td></td>
			<td>The maximum length that the property value can be.</td>
		</tr>
		
		<tr>
			<td>minimum</td>
			<td>numeric</td>
			<td>false</td>
			<td></td>
			<td>The minimum length that the property value can be.</td>
		</tr>
		
		<tr>
			<td>within</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>A list of two values (minimum and maximum) that the length of the property value must fall within.</td>
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
	
		<!--- Make sure that the `firstname` and `lastName` properties are not more than 50 characters and use square brackets to dynamically insert the property name when the error message is displayed to the user. (The `firstName` property will be displayed as "first name".) --->
		<cfset validatesLengthOf(properties="firstName,lastName", maximum=50, message="Please shorten your [property] please. 50 characters is the maximum length allowed.")>

		<!--- Make sure that the `password` property is between 4 and 15 characters --->
		<cfset validatesLengthOf(property="password", within="4,20", message="The password length must be between 4 and 20 characters.")>
