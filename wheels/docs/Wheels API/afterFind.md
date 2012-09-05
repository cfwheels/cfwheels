# afterFind()

## Description
Registers method(s) that should be called after an existing object has been initialized (which is usually done with the @findByKey or @findOne method).

## Function Syntax
	afterFind( [ methods ] )


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
			<td>methods</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Method name or list of method names that should be called when this callback event occurs in an object's life cycle (can also be called with the `method` argument).</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Instruct Wheels to call the `setTime` method after getting objects or records with one of the finder methods --->
		<cffunction name="init">
			<cfset afterFind("setTime")>
		</cffunction>

		<cffunction name="setTime">
			<cfset arguments.fetchedAt = Now()>
			<cfreturn arguments>
		</cffunction>
