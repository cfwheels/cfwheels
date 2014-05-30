# validateOnUpdate()

## Description
Registers method(s) that should be called to validate existing objects before they are updated.

## Function Syntax
	validateOnUpdate( [ methods, condition, unless ] )


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
			<td>methods</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Method name or list of method names to call. (Can also be called with the `method` argument.)</td>
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
	
		<cffunction name="init">
			<!--- Register the `check` method below to be called to validate existing objects before they are updated --->
			<cfset validateOnUpdate("checkPhoneNumber")>
		</cffunction>

		<cffunction name="checkPhoneNumber">
			<!--- Make sure area code is `614` --->
			<cfreturn Left(this.phoneNumber, 3) is "614">
		</cffunction>
