# resetCycle()

## Description
Resets a cycle so that it starts from the first list value the next time it is called.

## Function Syntax
	resetCycle( [ name ] )


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
			<td>default</td>
			<td>The name of the cycle to reset.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- alternating row colors and shrinking emphasis --->
		<cfoutput query="employees" group="departmentId">
			<div class="#cycle(values="even,odd", name="row")#">
				<ul>
					<cfoutput>
						<cfset rank = cycle(values="president,vice-president,director,manager,specialist,intern", name="position")>
						<li class="#rank#">#categories.categoryName#</li>
						<cfset resetCycle("emphasis")>
					</cfoutput>
				</ul>
			</div>
		</cfoutput>
