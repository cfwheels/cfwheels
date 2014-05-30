# validatesFormatOf()

## Description
Validates that the value of the specified property is formatted correctly by matching it against a regular expression using the `regEx` argument and/or against a built-in CFML validation type using the `type` argument (`creditcard`, `date`, `email`, etc.).

## Function Syntax
	validatesFormatOf( properties, [ regEx, type, message, when, allowBlank, condition, unless ] )


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
			<td>regEx</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Regular expression to verify against.</td>
		</tr>
		
		<tr>
			<td>type</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>One of the following types to verify against: `creditcard`, `date`, `email`, `eurodate`, `guid`, `social_security_number`, `ssn`, `telephone`, `time`, `URL`, `USdate`, `UUID`, `variableName`, `zipcode` (will be passed through to your CFML engine's `IsValid()` function).</td>
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
	
		<!--- Make sure that the user has entered a correct credit card --->
		<cfset validatesFormatOf(property="cc", type="creditcard")>

		<!--- Make sure that the user has entered an email address ending with the `.se` domain when the `ipCheck()` method returns `true`, and it's not Sunday. Also supply a custom error message that overrides the Wheels default one --->
		<cfset validatesFormatOf(property="email", regEx="^.*@.*\.se$", condition="ipCheck()", unless="DayOfWeek() IS 1", message="Sorry, you must have a Swedish email address to use this website.")>
