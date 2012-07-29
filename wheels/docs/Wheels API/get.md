# get()

## Description
Returns the current setting for the supplied Wheels setting or the current default for the supplied Wheels function argument.

## Function Syntax
	get( name, [ functionName ] )


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
			<td>name</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Variable name to get setting for.</td>
		</tr>
		
		<tr>
			<td>functionName</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Function name to get setting for.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Get the current value for the `tableNamePrefix` Wheels setting --->
		<cfset setting = get("tableNamePrefix")>

		<!--- Get the default for the `message` argument of the `validatesConfirmationOf` method  --->
		<cfset setting = get(functionName="validatesConfirmationOf", name="message")>
