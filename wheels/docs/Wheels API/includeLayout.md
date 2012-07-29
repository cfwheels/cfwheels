# includeLayout()

## Description
Includes the contents of another layout file. This is usually used to include a parent layout from within a child layout.

## Function Syntax
	includeLayout( [ name ] )


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
			<td>false</td>
			<td>layout</td>
			<td>Name of the layout file to include.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Make sure that the `sidebar` value is provided for the parent layout --->
		<cfsavecontent variable="categoriesSidebar">
			<cfoutput>
				<ul>
					#includePartial(categories)#
				</ul>
			</cfoutput>
		</cfsavecontent>
		<cfset contentFor(sidebar=categoriesSidebar)>
		
		<!--- Include parent layout at `views/layout.cfm` --->
		<cfoutput>
			#includeLayout("/layout.cfm")#
		</cfoutput>
