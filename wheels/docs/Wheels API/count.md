# count()

## Description
Returns the number of rows that match the arguments (or all rows if no arguments are passed in). Uses the SQL function `COUNT`. If no records can be found to perform the calculation on, `0` is returned.

## Function Syntax
	count( [ where, include, parameterize, includeSoftDeletes, reload ] )


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
			<td>where</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>This argument maps to the `WHERE` clause of the query. The following operators are supported: `=`, `!=`, `<>`, `<`, `<=`, `>`, `>=`, `LIKE`, `NOT LIKE`, `IN`, `NOT IN`, `IS NULL`, `IS NOT NULL`, `AND`, and `OR`. (Note that the key words need to be written in upper case.) You can also use parentheses to group statements. You do not need to specify the table name(s); Wheels will do that for you.</td>
		</tr>
		
		<tr>
			<td>include</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Associations that should be included in the query using `INNER` or `LEFT OUTER` joins (which join type that is used depends on how the association has been set up in your model). If all included associations are set on the current model, you can specify them in a list (e.g. `department,addresses,emails`). You can build more complex `include` strings by using parentheses when the association is set on an included model, like `album(artist(genre))`, for example. These complex `include` strings only work when `returnAs` is set to `query` though.</td>
		</tr>
		
		<tr>
			<td>parameterize</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to use `cfqueryparam` on all columns, or pass in a list of property names to use `cfqueryparam` on those only.</td>
		</tr>
		
		<tr>
			<td>includeSoftDeletes</td>
			<td>boolean</td>
			<td>false</td>
			<td>false</td>
			<td>You can set this argument to `true` to include soft-deleted records in the results.</td>
		</tr>
		
		<tr>
			<td>reload</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to reload the object from the database once an insert/update has completed.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Count how many authors there are in the table --->
		<cfset authorCount = model("author").count()>

		<!--- Count how many authors that have a last name starting with an "A" --->
		<cfset authorOnACount = model("author").count(where="lastName LIKE 'A%'")>

		<!--- Count how many authors that have written books starting with an "A" --->
		<cfset authorWithBooksOnACount = model("author").count(include="books", where="booktitle LIKE 'A%'")>
		
		<!--- Count the number of comments on a specific post (a `hasMany` association from `post` to `comment` is required) --->
		<!--- The `commentCount` method will call `model("comment").count(where="postId=#post.id#")` internally --->
		<cfset aPost = model("post").findByKey(params.postId)>
		<cfset amount = aPost.commentCount()>
