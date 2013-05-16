# select()

## Description
Builds and returns a string containing a `select` form control based on the supplied `objectName` and `property`. Note: Pass any additional arguments like `class`, `rel`, and `id`, and the generated tag will also include those values as HTML attributes.

## Function Syntax
	select( objectName, property, options, [ association, position, includeBlank, valueField, textField, label, labelPlacement, prepend, append, prependToLabel, appendToLabel, errorElement, errorClass ] )


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
			<td>options</td>
			<td>any</td>
			<td>true</td>
			<td></td>
			<td>A collection to populate the select form control with. Can be a query recordset or an array of objects.</td>
		</tr>
		
		<tr>
			<td>includeBlank</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Whether to include a blank option in the select form control. Pass `true` to include a blank line or a string that should represent what display text should appear for the empty value (for example, "- Select One -").</td>
		</tr>
		
		<tr>
			<td>valueField</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The column or property to use for the value of each list element. Used only when a query or array of objects has been supplied in the `options` argument.</td>
		</tr>
		
		<tr>
			<td>textField</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>The column or property to use for the value of each list element that the end user will see. Used only when a query or array of objects has been supplied in the `options` argument.</td>
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
	
		<!--- Example 1: Basic `select` field with `label` and required `objectName` and `property` arguments --->
		<!--- - Controller code --->
		<cfset authors = model("author").findAll()>

		<!--- - View code --->
		<cfoutput>
		    <p>#select(objectName="book", property="authorId", options=authors)#</p>
		</cfoutput>

		<!--- Example 2: Shows `select` fields for selecting order statuses for all shipments provided by the `orders` association and nested properties --->
		<!--- - Controller code --->
		<cfset shipment = model("shipment").findByKey(key=params.key, where="shipments.statusId=#application.NEW_STATUS_ID#", include="order")>
		<cfset statuses = model("status").findAll(order="name")>

		<!--- - View code --->
		<cfoutput>
			<cfloop from="1" to="#ArrayLen(shipments.orders)#" index="i">
				#select(label="Order ##shipments.orders[i].orderNum#", objectName="shipment", association="orders", position=i, property="statusId", options=statuses)#
			</cfloop>
		</cfoutput>
