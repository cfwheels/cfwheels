# flashMessages()

## Description
Displays a marked-up listing of messages that exists in the Flash.

## Function Syntax
	flashMessages( [ keys, class, includeEmptyContainer, lowerCaseDynamicClassValues ] )


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
			<td>keys</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The key (or list of keys) to show the value for. You can also use the `key` argument instead for better readability when accessing a single key.</td>
		</tr>
		
		<tr>
			<td>class</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>HTML `class` to set on the `div` element that contains the messages.</td>
		</tr>
		
		<tr>
			<td>includeEmptyContainer</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Includes the DIV container even if the flash is empty.</td>
		</tr>
		
		<tr>
			<td>lowerCaseDynamicClassValues</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Outputs all class attribute values in lower case (except the main one).</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- In the controller action --->
		<cfset flashInsert(success="Your post was successfully submitted.")>
		<cfset flashInsert(alert="Don't forget to tweet about this post!")>
		<cfset flashInsert(error="This is an error message.")>

		<!--- In the layout or view --->
		<cfoutput>
			#flashMessages()#
		</cfoutput>
		<!---
			Generates this (sorted alphabetically):
			<div class="flashMessages">
				<p class="alertMessage">
					Don't forget to tweet about this post!
				</p>
				<p class="errorMessage">
					This is an error message.
				</p>
				<p class="successMessage">
					Your post was successfully submitted.
				</p>
			</div>
		--->

		<!--- Only show the "success" key in the view --->
		<cfoutput>
			#flashMessages(key="success")#
		</cfoutput>
		<!---
			Generates this:
			<div class="flashMessage">
				<p class="successMessage">
					Your post was successfully submitted.
				</p>
			</div>
		--->

		<!--- Show only the "success" and "alert" keys in the view, in that order --->
		<cfoutput>
			#flashMessages(keys="success,alert")#
		</cfoutput>
		<!---
			Generates this (sorted alphabetically):
			<div class="flashMessages">
				<p class="successMessage">
					Your post was successfully submitted.
				</p>
				<p class="alertMessage">
					Don't forget to tweet about this post!
				</p>
			</div>
		--->
