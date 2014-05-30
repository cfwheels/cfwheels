# checkBox()

## Description
Builds and returns a string containing a check box form control based on the supplied `objectName` and `property`. In most cases, this function generates a form field that should represent a `boolean` style field in your data. Use @checkBoxTag or @hasManyCheckBox to generate check boxes for selecting multiple values. Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes.

## Function Syntax
	checkBox( objectName, property, [ association, position, checkedValue, uncheckedValue, label, labelPlacement, prepend, append, prependToLabel, appendToLabel, errorElement, errorClass ] )


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
			<td>objectName</td>
			<td>any</td>
			<td>true</td>
			<td></td>
			<td>The variable name of the object to build the form control for.</td>
		</tr>
		
		<tr>
			<td>property</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>The name of the property to use in the form control.</td>
		</tr>
		
		<tr>
			<td>association</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The name of the association that the property is located on. Used for building nested forms that work with nested properties. If you are building a form with deep nesting, simply pass in a list to the nested object, and Wheels will figure it out.</td>
		</tr>
		
		<tr>
			<td>position</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The position used when referencing a `hasMany` relationship in the `association` argument. Used for building nested forms that work with nested properties. If you are building a form with deep nestings, simply pass in a list of positions, and Wheels will figure it out.</td>
		</tr>
		
		<tr>
			<td>checkedValue</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The value of the check box when it's in the `checked` state.</td>
		</tr>
		
		<tr>
			<td>uncheckedValue</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The value of the check box when it's in the `unchecked` state.</td>
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
		
		<tr>
			<td>errorElement</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>HTML tag to wrap the form control with when the object contains errors.</td>
		</tr>
		
		<tr>
			<td>errorClass</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The class name of the HTML tag that wraps the form control when there are errors.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Basic example of a check box for a boolean field --->
		<cfoutput>
		    #checkBox(objectName="photo", property="isPublic", label="Display this photo publicly.")#
		</cfoutput>

		<!--- Shows check boxes for selecting public access for all photos provided by the `photos` association and nested properties --->
		<cfoutput>
			<cfloop from="1" to="#ArrayLen(user.photos)#" index="i">
				<div>
					<h3>#user.photos[i].title#:</h3>
					<div>
						#checkBox(objectName="user", association="photos", position=i, property="isPublic", label="Display this photo publicly.")#
					</div>
				</div>
			</cfloop>
		</cfoutput>
