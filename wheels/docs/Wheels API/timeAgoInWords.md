# timeAgoInWords()

## Description
Pass in a date to this method, and it will return a string describing the approximate time difference between that date and the current date.

## Function Syntax
	timeAgoInWords( fromTime, [ includeSeconds, toTime ] )


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
			<td>includeSeconds</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Whether or not to include the number of seconds in the returned string.</td>
		</tr>
		
		<tr>
			<td>toTime</td>
			<td>date</td>
			<td>false</td>
			<td>[runtime expression]</td>
			<td>Date to compare to.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<cfset aWhileAgo = Now() - 30>
		<cfoutput>#timeAgoInWords(aWhileAgo)#</cfoutput>
