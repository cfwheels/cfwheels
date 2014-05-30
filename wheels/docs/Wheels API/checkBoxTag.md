# checkBoxTag()

## Description
Builds and returns a string containing a check box form control based on the supplied `name`. Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes.

## Function Syntax
	checkBoxTag( name, [ checked, value, uncheckedValue, label, labelPlacement, prepend, append, prependToLabel, appendToLabel ] )


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
			<td>checked</td>
			<td>boolean</td>
			<td>false</td>
			<td>false</td>
			<td>Whether or not the check box should be checked by default.</td>
		</tr>
		
		<tr>
			<td>value</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Value of check box in its `checked` state.</td>
		</tr>
		
		<tr>
			<td>uncheckedValue</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The value of the check box when it's on the `unchecked` state.</td>
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
	
		<!--- Example 1: Basic usage involves a `label`, `name`, and `value` --->
		<cfoutput>
		    #checkBoxTag(name="subscribe", value="true", label="Subscribe to our newsletter", checked=false)#
		</cfoutput>
		
		<!--- Example 2: Loop over a query to display choices and whether or not they are checked --->
		<!--- - Controller code --->
		<cfset pizza = model("pizza").findByKey(session.pizzaId)>
		<cfset selectedToppings = pizza.toppings()>
		<cfset toppings = model("topping").findAll(order="name")>
		
		<!--- View code --->
		<fieldset>
			<legend>Toppings</legend>
			<cfoutput query="toppings">
				#checkBoxTag(name="toppings", value="true", label=toppings.name, checked=YesNoFormat(ListFind(ValueList(selectedToppings.id), toppings.id))#
			</cfoutput>
		</fieldset>
