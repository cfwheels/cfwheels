# filters()

## Description
Tells Wheels to run a function before an action is run or after an action has been run. You can also specify multiple functions and actions.

## Function Syntax
	filters( through, [ type, only, except ] )


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
			<td>through</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Function(s) to execute before or after the action(s).</td>
		</tr>
		
		<tr>
			<td>type</td>
			<td>string</td>
			<td>false</td>
			<td>before</td>
			<td>Whether to run the function(s) before or after the action(s).</td>
		</tr>
		
		<tr>
			<td>only</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Pass in a list of action names (or one action name) to tell Wheels that the filter function(s) should only be run on these actions.</td>
		</tr>
		
		<tr>
			<td>except</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Pass in a list of action names (or one action name) to tell Wheels that the filter function(s) should be run on all actions except the specified ones.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Always execute `restrictAccess` before all actions in this controller --->
		<cfset filters("restrictAccess")>

		<!--- Always execute `isLoggedIn` and `checkIPAddress` (in that order) before all actions in this controller except the `home` and `login` actions --->
		<cfset filters(through="isLoggedIn,checkIPAddress", except="home,login")>
