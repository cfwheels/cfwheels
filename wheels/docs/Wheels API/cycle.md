# cycle()

## Description
Cycles through list values every time it is called.

## Function Syntax
	cycle( values, [ name ] )


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
			<td>values</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>List of values to cycle through.</td>
		</tr>
		
		<tr>
			<td>name</td>
			<td>string</td>
			<td>false</td>
			<td>default</td>
			<td>Name to give the cycle. Useful when you use multiple cycles on a page.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Alternating table row colors --->
		<table>
			<thead>
				<tr>
					<th>Name</th>
					<th>Phone</th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="employees">
					<tr class="#cycle("odd,even")#">
						<td>#employees.name#</td>
						<td>#employees.phone#</td>
					</tr>
				</cfoutput>
			</tbody>
		</table>
		
		<!--- Alternating row colors and shrinking emphasis --->
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
