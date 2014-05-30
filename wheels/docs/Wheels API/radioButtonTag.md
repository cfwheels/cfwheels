# radioButtonTag()

## Description
Builds and returns a string containing a radio button form control based on the supplied `name`. Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes.

## Function Syntax
	radioButtonTag( name, value, [ checked, label, labelPlacement, prepend, append, prependToLabel, appendToLabel ] )


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
			<td>value</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>Value to populate in tag's `value` attribute.</td>
		</tr>
		
		<tr>
			<td>checked</td>
			<td>boolean</td>
			<td>false</td>
			<td>false</td>
			<td>Whether or not to check the radio button by default.</td>
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
	
		<!--- Basic usage usually involves a `label`, `name`, `value`, and `checked` value --->
		<cfoutput>
		    <fieldset>
				<legend>Gender</legend>
			    #radioButtonTag(name="gender", value="m", label="Male", checked=true)#<br />
		        #radioButtonTag(name="gender", value="f", label="Female")#
			</fieldset>
		</cfoutput>
