# timeUntilInWords()

## Description
Pass in a date to this method, and it will return a string describing the approximate time difference between the current date and that date.

## Function Syntax
	timeUntilInWords( toTime, [ includeSeconds, fromTime ] )


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
		
		<tr>
			<td>fromTime</td>
			<td>date</td>
			<td>false</td>
			<td>[runtime expression]</td>
			<td>Date to compare from.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<cfset aLittleAhead = Now() + 30>
		<cfoutput>#timeUntilInWords(aLittleAhead)#</cfoutput>
