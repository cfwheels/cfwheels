# verifies()

## Description
Instructs Wheels to verify that some specific criterias are met before running an action. NOTE: All undeclared arguments will be passed to `redirectTo()` call if a handler is not specified.

## Function Syntax
	verifies( [ only, except, post, get, ajax, cookie, session, params, handler, cookieTypes, sessionTypes, paramsTypes ] )


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
			<td>only</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>List of action names to limit this verification to.</td>
		</tr>
		
		<tr>
			<td>except</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>List of action names to exclude this verification from.</td>
		</tr>
		
		<tr>
			<td>post</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to verify that this is a `POST` request.</td>
		</tr>
		
		<tr>
			<td>get</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to verify that this is a `GET` request.</td>
		</tr>
		
		<tr>
			<td>ajax</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to verify that this is an AJAX request.</td>
		</tr>
		
		<tr>
			<td>cookie</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Verify that the passed in variable name exists in the `cookie` scope.</td>
		</tr>
		
		<tr>
			<td>session</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Verify that the passed in variable name exists in the `session` scope.</td>
		</tr>
		
		<tr>
			<td>params</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Verify that the passed in variable name exists in the `params` struct.</td>
		</tr>
		
		<tr>
			<td>handler</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Pass in the name of a function that should handle failed verifications. The default is to just abort the request when a verification fails.</td>
		</tr>
		
		<tr>
			<td>cookieTypes</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>List of types to check each listed `cookie` value against (will be passed through to your CFML engine's `IsValid` function).</td>
		</tr>
		
		<tr>
			<td>sessionTypes</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>List of types to check each list `session` value against (will be passed through to your CFML engine's `IsValid` function).</td>
		</tr>
		
		<tr>
			<td>paramsTypes</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>List of types to check each `params` value against (will be passed through to your CFML engine's `IsValid` function).</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Tell Wheels to verify that the `handleForm` action is always a `POST` request when executed --->
		<cfset verifies(only="handleForm", post=true)>

		<!--- Make sure that the edit action is a `GET` request, that `userId` exists in the `params` struct, and that it's an integer --->
		<cfset verifies(only="edit", get=true, params="userId", paramsTypes="integer")>

		<!--- Just like above, only this time we want to invoke a custom method in our controller to handle the request when it is invalid --->
		<cfset verifies(only="edit", get=true, params="userId", paramsTypes="integer", handler="myCustomMethod")>
		
		<!--- Just like above, only this time instead of specifying a handler, we want to `redirect` the visitor to the index action of the controller and show an error in The Flash when the request is invalid --->
		<cfset verifies(only="edit", get=true, params="userId", paramsTypes="integer", action="index", error="Invalid userId")>
