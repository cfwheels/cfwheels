# flash()

## Description
Returns the value of a specific key in the Flash (or the entire Flash as a struct if no key is passed in).

## Function Syntax
	flash( [ key ] )


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
			<td>key</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The key to get the value for.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Display "message" item in flash --->
		<cfoutput>
			<cfif flashKeyExists("message")>
				<p class="message">
					#flash("message")#
				</p>
			</cfif>
		</cfoutput>

		<!--- Display all flash items --->
		<cfoutput>
			<cfset allFlash = flash()>
			<cfloop list="#StructKeyList(allFlash)#" index="flashItem">
				<p class="#flashItem#">
					#flash(flashItem)#
				</p>
			</cfloop>
		</cfoutput>
