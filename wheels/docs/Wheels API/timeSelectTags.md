# timeSelectTags()

## Description
Builds and returns a string containing three select form controls for hour, minute, and second based on `name`.

## Function Syntax
	timeSelectTags( name, [ selected, order, separator, minuteStep, secondStep, includeBlank, label, labelPlacement, prepend, append, prependToLabel, appendToLabel, combine, twelveHour ] )


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
			<td>Value of option that should be selected by default.</td>
		</tr>
		
		<tr>
			<td>order</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Use to change the order of or exclude time select tags.</td>
		</tr>
		
		<tr>
			<td>separator</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Use to change the character that is displayed between the time select tags.</td>
		</tr>
		
		<tr>
			<td>minuteStep</td>
			<td>numeric</td>
			<td>false</td>
			<td></td>
			<td>Pass in `10` to only show minute 10, 20, 30, etc.</td>
		</tr>
		
		<tr>
			<td>secondStep</td>
			<td>numeric</td>
			<td>false</td>
			<td></td>
			<td>Pass in `10` to only show seconds 10, 20, 30, etc.</td>
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
			<td>The label text to use in the form control. The label will be applied to all `select` tags, but you can pass in a list to cutomize each one individually.</td>
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
		
		<tr>
			<td>combine</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Set to `false` to not combine the select parts into a single `DateTime` object.</td>
		</tr>
		
		<tr>
			<td>twelveHour</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>whether to display the hours in 24 or 12 hour format. 12 hour format has AM/PM drop downs</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- This "Tag" version of function accepts `name` and `selected` instead of binding to a model object --->
		<cfoutput>
		    #timeSelectTags(name="timeOfMeeting" selected=params.timeOfMeeting)#
		</cfoutput>
		
		<!--- Show fields for `hour` and `minute` only --->
		<cfoutput>
			#timeSelectTags(name="timeOfMeeting", selected=params.timeOfMeeting, order="hour,minute")#
		</cfoutput>
