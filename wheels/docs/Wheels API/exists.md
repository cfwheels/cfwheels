# exists()

## Description
Checks if a record exists in the table. You can pass in either a primary key value to the `key` argument or a string to the `where` argument.

## Function Syntax
	exists( [ key, where, reload, parameterize ] )


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
			<td>key</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Primary key value(s) of the record to fetch. Separate with comma if passing in multiple primary key values. Accepts a string, list, or a numeric value.</td>
		</tr>
		
		<tr>
			<td>where</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>This argument maps to the `WHERE` clause of the query. The following operators are supported: `=`, `!=`, `<>`, `<`, `<=`, `>`, `>=`, `LIKE`, `NOT LIKE`, `IN`, `NOT IN`, `IS NULL`, `IS NOT NULL`, `AND`, and `OR`. (Note that the key words need to be written in upper case.) You can also use parentheses to group statements. You do not need to specify the table name(s); Wheels will do that for you.</td>
		</tr>
		
		<tr>
			<td>reload</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to force Wheels to query the database even though an identical query may have been run in the same request. (The default in Wheels is to get the second query from the request-level cache.)</td>
		</tr>
		
		<tr>
			<td>parameterize</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to use `cfqueryparam` on all columns, or pass in a list of property names to use `cfqueryparam` on those only.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Checking if Joe exists in the database --->
		<cfset result = model("user").exists(where="firstName='Joe'")>

		<!--- Checking if a specific user exists based on a primary key valued passed in through the URL/form in an if statement --->
		<cfif model("user").exists(keyparams.key)>
			<!--- Do something... --->
		</cfif>

		<!--- If you have a `belongsTo` association setup from `comment` to `post`, you can do a scoped call. (The `hasPost` method below will call `model("post").exists(comment.postId)` internally.) --->
		<cfset comment = model("comment").findByKey(params.commentId)>
		<cfset commentHasAPost = comment.hasPost()>

		<!--- If you have a `hasOne` association setup from `user` to `profile`, you can do a scoped call. (The `hasProfile` method below will call `model("profile").exists(where="userId=#user.id#")` internally.) --->
		<cfset user = model("user").findByKey(params.userId)>
		<cfset userHasProfile = user.hasProfile()>

		<!--- If you have a `hasMany` association setup from `post` to `comment`, you can do a scoped call. (The `hasComments` method below will call `model("comment").exists(where="postid=#post.id#")` internally.) --->
		<cfset post = model("post").findByKey(params.postId)>
		<cfset postHasComments = post.hasComments()>
