# onlyProvides()

## Description
Use this in an individual controller action to define which formats the action will respond with. This can be used to define provides behavior in individual actions or to override a global setting set with @provides in the controller's `init()`.

## Function Syntax
	onlyProvides( [ formats, action ] )


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
			<td>formats</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td></td>
		</tr>
		
		<tr>
			<td>action</td>
			<td>string</td>
			<td>false</td>
			<td>[runtime expression]</td>
			<td></td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- In your controller --->
		<cffunction name="init">
			<cfset provides("html,xml,json")>
		</cffunction>
		
		<!--- This action will provide the formats defined in `init()` above --->
		<cffunction name="list">
			<cfset products = model("product").findAll()>
			<cfset renderWith(products)>
		</cffunction>
		
		<!--- This action will only provide the `html` type and will ignore what was defined in the call to `provides()` in the `init()` method above --->
		<cffunction name="new">
			<cfset onlyProvides("html")>
			<cfset model("product").new()>
		</cffunction>
