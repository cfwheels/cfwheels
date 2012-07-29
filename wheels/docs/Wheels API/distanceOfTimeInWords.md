# distanceOfTimeInWords()

## Description
Pass in two dates to this method, and it will return a string describing the difference between them.

## Function Syntax
	distanceOfTimeInWords( fromTime, toTime, [ includeSeconds ] )


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
			<td>fromTime</td>
			<td>date</td>
			<td>true</td>
			<td></td>
			<td>Date to compare from.</td>
		</tr>
		
		<tr>
			<td>toTime</td>
			<td>date</td>
			<td>true</td>
			<td></td>
			<td>Date to compare to.</td>
		</tr>
		
		<tr>
			<td>includeSeconds</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Whether or not to include the number of seconds in the returned string.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
	<cfset aWhileAgo = Now() - 30>
	<cfset rightNow = Now()>
	<cfoutput>#distanceOfTimeInWords(aWhileAgo, rightNow)#</cfoutput>
