# radioButtonTagGroup()

## Description
Builds and returns a string for a group of radio buttons and labels. If you pass in [value] to any of the arguments that get appplied to each individual radio button (`append` for example), it will be replaced by the real value in the current iteration. You can pass in different `prepend`, `append` etc arguments by using a list.

## Function Syntax
	radioButtonTagGroup( name, values, [ checkedValue, order, prependToGroup, appendToGroup, label, labelPlacement, prepend, append, prependToLabel, appendToLabel ] )


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
			<td>values</td>
			<td>struct</td>
			<td>true</td>
			<td></td>
			<td>Struct containing keys/values for the radio buttons and labels to be created.</td>
		</tr>
		
		<tr>
			<td>checkedValue</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The value of the radio button that should be checked.</td>
		</tr>
		
		<tr>
			<td>order</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>List of struct keys in the order you want them displayed (to override the alphabetical default).</td>
		</tr>
		
		<tr>
			<td>prependToGroup</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String to prepend to the entire group of radio buttons.</td>
		</tr>
		
		<tr>
			<td>appendToGroup</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>String to append to the entire group of radio buttons.</td>
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
	
		<!--- Simple yes/no selection --->
		<cfset choices = StructNew()>
		<cfset choices.1 = "Yes">
		<cfset choices.0 = "No">
		<cfoutput>
			#radioButtonTagGroup(name="yesorno", values=choices)#
		</cfoutput>

		<!--- Output three radio buttons for choosing how to perform a search --->
		<cfset values = StructNew()>
		<cfset values.all = "Results containing all of the words.">
		<cfset values.any = "Results containing any of the words.">
		<cfset values.exact = "Results containing the exact phrase.">
		<cfoutput>
			#radioButtonTagGroup(name="type", values=values, checkedValue=params.type, prependToGroup="<div class=""clearfix""><label>Show:</label><div class=""input""><ul class=""inputs-list"">", appendToGroup="</ul></div></div>", prepend="<li><label>", append="<span>[value]</span></label></li>")#
		</cfoutput>
