# yearSelectTag()

## Description
Builds and returns a string containing a select form control for a range of years based on the supplied `name`.

## Function Syntax
	yearSelectTag( name, [ selected, startYear, endYear, includeBlank, label, labelPlacement, prepend, append, prependToLabel, appendToLabel ] )


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
			<td>true</td>
			<td></td>
			<td>Name to populate in tag's `name` attribute.</td>
		</tr>
		
		<tr>
			<td>selected</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The year that should be selected initially.</td>
		</tr>
		
		<tr>
			<td>startYear</td>
			<td>numeric</td>
			<td>false</td>
			<td></td>
			<td>First year in select list.</td>
		</tr>
		
		<tr>
			<td>endYear</td>
			<td>numeric</td>
			<td>false</td>
			<td></td>
			<td>Last year in select list.</td>
		</tr>
		
		<tr>
			<td>includeBlank</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Whether to include a blank option in the select form control. Pass `true` to include a blank line or a string that should represent what display text should appear for the empty value (for example, "- Select One -").</td>
		</tr>
		
		<tr>
			<td>label</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The label text to use in the form control.</td>
		</tr>
		
		<tr>
			<td>labelPlacement</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Whether to place the label `before`, `after`, or wrapped `around` the form control. Label text placement can be controled using `aroundLeft` or `aroundRight`</td>
		</tr>
		
		<tr>
			<td>prepend</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String to prepend to the form control. Useful to wrap the form control with HTML tags.</td>
		</tr>
		
		<tr>
			<td>append</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String to append to the form control. Useful to wrap the form control with HTML tags.</td>
		</tr>
		
		<tr>
			<td>prependToLabel</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String to prepend to the form control's `label`. Useful to wrap the form control with HTML tags.</td>
		</tr>
		
		<tr>
			<td>appendToLabel</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String to append to the form control's `label`. Useful to wrap the form control with HTML tags.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- View code --->
		<cfoutput>
		    #yearSelectTag(name="yearOfBirthday", selected=params.yearOfBirthday)#
		</cfoutput>
		
		<!--- Only allow selection of year to be for the past 50 years, minimum being 18 years ago --->
		<cfset fiftyYearsAgo = Now() - 50>
		<cfset eighteenYearsAgo = Now() - 18>
		<cfoutput>
			#yearSelectTag(name="yearOfBirthday", selected=params.yearOfBirthday, startYear=fiftyYearsAgo, endYear=eighteenYearsAgo)#
		</cfoutput>
