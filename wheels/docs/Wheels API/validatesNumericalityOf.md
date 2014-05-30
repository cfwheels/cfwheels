# validatesNumericalityOf()

## Description
Validates that the value of the specified property is numeric.

## Function Syntax
	validatesNumericalityOf( properties, [ message, when, allowBlank, onlyInteger, condition, unless, odd, even, greaterThan, greaterThanOrEqualTo, equalTo, lessThan, lessThanOrEqualTo ] )


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
			<td>onlyInteger</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Specifies whether the property value must be an integer.</td>
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
		
		<tr>
			<td>odd</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Specifies whether or not the value must be an odd number.</td>
		</tr>
		
		<tr>
			<td>even</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Specifies whether or not the value must be an even number.</td>
		</tr>
		
		<tr>
			<td>greaterThan</td>
			<td>numeric</td>
			<td>false</td>
			<td></td>
			<td>Specifies whether or not the value must be greater than the supplied value.</td>
		</tr>
		
		<tr>
			<td>greaterThanOrEqualTo</td>
			<td>numeric</td>
			<td>false</td>
			<td></td>
			<td>Specifies whether or not the value must be greater than or equal the supplied value.</td>
		</tr>
		
		<tr>
			<td>equalTo</td>
			<td>numeric</td>
			<td>false</td>
			<td></td>
			<td>Specifies whether or not the value must be equal to the supplied value.</td>
		</tr>
		
		<tr>
			<td>lessThan</td>
			<td>numeric</td>
			<td>false</td>
			<td></td>
			<td>Specifies whether or not the value must be less than the supplied value.</td>
		</tr>
		
		<tr>
			<td>lessThanOrEqualTo</td>
			<td>numeric</td>
			<td>false</td>
			<td></td>
			<td>Specifies whether or not the value must be less than or equal the supplied value.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Make sure that the score is a number with no decimals but only when a score is supplied. (Tetting `allowBlank` to `true` means that objects are allowed to be saved without scores, typically resulting in `NULL` values being inserted in the database table) --->
		<cfset validatesNumericalityOf(property="score", onlyInteger=true, allowBlank=true, message="Please enter a correct score.")>
