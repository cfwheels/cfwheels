# findOne()

## Description
Fetches the first record found based on the `WHERE` and `ORDER BY` clauses. With the default settings (i.e. the `returnAs` argument set to `object`), a model object will be returned if the record is found and the boolean value `false` if not. Instead of using the `where` argument, you can create cleaner code by making use of a concept called dynamic finders.

## Function Syntax
	findOne( [ where, order, select, include, cache, reload, parameterize, returnAs, includeSoftDeletes ] )


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
			<td>order</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Maps to the `ORDER BY` clause of the query. You do not need to specify the table name(s); Wheels will do that for you.</td>
		</tr>
		
		<tr>
			<td>select</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Determines how the `SELECT` clause for the query used to return data will look.	You can pass in a list of the properties (which map to columns) that you want returned from your table(s). If you don't set this argument at all, Wheels will select all properties from your table(s). If you specify a table name (e.g. `users.email`) or alias a column (e.g. `fn AS firstName`) in the list, then the entire list will be passed through unchanged and used in the `SELECT` clause of the query. By default, all column names in tables `JOIN`ed via the `include` argument will be prepended with the singular version of the included table name.</td>
		</tr>
		
		<tr>
			<td>include</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Associations that should be included in the query using `INNER` or `LEFT OUTER` joins (which join type that is used depends on how the association has been set up in your model). If all included associations are set on the current model, you can specify them in a list (e.g. `department,addresses,emails`). You can build more complex `include` strings by using parentheses when the association is set on an included model, like `album(artist(genre))`, for example. These complex `include` strings only work when `returnAs` is set to `query` though.</td>
		</tr>
		
		<tr>
			<td>cache</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>If you want to cache the query, you can do so by specifying the number of minutes you want to cache the query for here. If you set it to `true`, the default cache time will be used (60 minutes).</td>
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
		
		<tr>
			<td>returnAs</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Set this to `query` to return as a single-row query result set. Set this to `object` to return as an object.</td>
		</tr>
		
		<tr>
			<td>includeSoftDeletes</td>
			<td>boolean</td>
			<td>false</td>
			<td>false</td>
			<td>You can set this argument to `true` to include soft-deleted records in the results.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Getting the most recent order as an object from the database --->
		<cfset order = model("order").findOne(order="datePurchased DESC")>

		<!--- Using a dynamic finder to get the first person with the last name `Smith`. Same as calling `model("user").findOne(where"lastName='smith'")` --->
		<cfset person = model("user").findOneByLastName("Smith")>

		<!--- Getting a specific user using a dynamic finder. Same as calling `model("user").findOne(where"email='someone@somewhere.com' AND password='mypass'")` --->
		<cfset user = model("user").findOneByEmailAndPassword("someone@somewhere.com,mypass")>

		<!--- If you have a `hasOne` association setup from `user` to `profile`, you can do a scoped call. (The `profile` method below will call `model("profile").findOne(where="userId=#user.id#")` internally) --->
		<cfset user = model("user").findByKey(params.userId)>
		<cfset profile = user.profile()>

		<!--- If you have a `hasMany` association setup from `post` to `comment`, you can do a scoped call. (The `findOneComment` method below will call `model("comment").findOne(where="postId=#post.id#")` internally) --->
		<cfset post = model("post").findByKey(params.postId)>
		<cfset comment = post.findOneComment(where="text='I Love Wheels!'")>
