# usesLayout()

## Description
Used within a controller's `init()` method to specify controller- or action-specific layouts.

## Function Syntax
	usesLayout( template, [ ajax, except, only, useDefault ] )


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
			<td>template</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Name of the layout template or method name you want to use</td>
		</tr>
		
		<tr>
			<td>ajax</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Name of the layout template you want to use for AJAX requests</td>
		</tr>
		
		<tr>
			<td>except</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>List of actions that SHOULD NOT get the layout</td>
		</tr>
		
		<tr>
			<td>only</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>List of action that SHOULD ONLY get the layout</td>
		</tr>
		
		<tr>
			<td>useDefault</td>
			<td>boolean</td>
			<td>false</td>
			<td>true</td>
			<td>When specifying conditions or a method, pass `true` to use the default `layout.cfm` if none of the conditions are met</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!---
			Example 1: We want this layout to be used as the default throughout the entire
			controller, except for the myajax action
		 --->
		<cffunction name="init">
			<cfset usesLayout(template="myLayout", except="myajax")>
		</cffunction>
		
		<!---
			Example 2: Use a custom layout for these actions but use the default layout.cfm
			for the rest
		--->
		<cffunction name="init">
			<cfset usesLayout(template="myLayout", only="termsOfService,shippingPolicy")>
		</cffunction>
		
		<!--- Example 3: Define a custom method to decide which layout to display --->
		<cffunction name="init">
			<cfset usesLayout("setLayout")>
		</cffunction>
		
		<cffunction name="setLayout">
			<!--- Use holiday theme for the month of December --->
			<cfif Month(Now()) eq 12>
				<cfreturn "holiday">
			<!--- Otherwise, use default layout by returning `true` --->
			<cfelse>
				<cfreturn true>
			</cfif>
		</cffunction>
