# validatesExclusionOf()

## Description
Validates that the value of the specified property does not exist in the supplied list.

## Function Syntax
	validatesExclusionOf( properties, list, [ message, when, allowBlank, condition, unless ] )


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
			<td>list</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Single value or list of values that should not be allowed.</td>
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
	
		<!--- Do not allow "PHP" or "Fortran" to be saved to the database as a cool language --->
		<cfset validatesExclusionOf(property="coolLanguage", list="php,fortran", message="Haha, you can not be serious. Try again, please.")>
