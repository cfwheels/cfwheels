# validate()

## Description
Registers method(s) that should be called to validate objects before they are saved.

## Function Syntax
validate( [ methods, condition, unless, when ] )


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
		
		<tr>
			<td>when</td>
			<td>string</td>
			<td>false</td>
			<td>onSave</td>
			<td>Pass in `onCreate` or `onUpdate` to limit when this validation occurs (by default validation will occur on both create and update, i.e. `onSave`).</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<cffunction name="init">
			<!--- Register the `checkPhoneNumber` method below to be called to validate objects before they are saved --->
			<cfset validate("checkPhoneNumber")>
		</cffunction>

		<cffunction name="checkPhoneNumber">
			<!--- Make sure area code is `614` --->
			<cfreturn Left(this.phoneNumber, 3) is "614">
		</cffunction>
