# pluralize()

## Description
Returns the plural form of the passed in word. Can also pluralize a word based on a value passed to the `count` argument.

## Function Syntax
	pluralize( word, [ count, returnCount ] )


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
			<td>word</td>
			<td>string</td>
			<td>true</td>
			<td></td>
			<td>The word to pluralize.</td>
		</tr>
		
		<tr>
			<td>count</td>
			<td>numeric</td>
			<td>false</td>
			<td>-1</td>
			<td>Pluralization will occur when this value is not `1`.</td>
		</tr>
		
		<tr>
			<td>returnCount</td>
			<td>boolean</td>
			<td>false</td>
			<td>true</td>
			<td>Will return `count` prepended to the pluralization when `true` and `count` is not `-1`.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Pluralize a word, will result in "people" --->
		#pluralize("person")#

		<!--- Pluralize based on the count passed in --->
		Your search returned #pluralize(word="person", count=users.RecordCount)#
