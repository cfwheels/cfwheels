# pagination()

## Description
Returns a struct with information about the specificed paginated query. The keys that will be included in the struct are `currentPage`, `totalPages` and `totalRecords`.

## Function Syntax
	pagination( [ handle ] )


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
			<td>handle</td>
			<td>string</td>
			<td>false</td>
			<td>query</td>
			<td>The handle given to the query to return pagination information for.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<cfparam name="params.page" default="1">
		<cfset allAuthors = model("author").findAll(page=params.page, perPage=25, order="lastName", handle="authorsData")>
		<cfset paginationData = pagination("authorsData")>
