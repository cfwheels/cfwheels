# findAll()

## Description
Returns records from the database table mapped to this model according to the arguments passed in. (Use the `where` argument to decide which records to get, use the `order` argument to set in what order those records should be returned, and so on). The records will be returned as either a `cfquery` result set or an array of objects (depending on what the `returnAs` argument is set to). Instead of using the `where` argument, you can create cleaner code by making use of a concept called dynamic finders.

## Function Syntax
	findAll( [ where, order, group, select, distinct, include, maxRows, page, perPage, count, handle, cache, reload, parameterize, returnAs, returnIncluded, callbacks, includeSoftDeletes ] )


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
			<td>group</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Maps to the `GROUP BY` clause of the query. You do not need to specify the table name(s); Wheels will do that for you.</td>
		</tr>
		
		<tr>
			<td>select</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Determines how the `SELECT` clause for the query used to return data will look.	You can pass in a list of the properties (which map to columns) that you want returned from your table(s). If you don't set this argument at all, Wheels will select all properties from your table(s). If you specify a table name (e.g. `users.email`) or alias a column (e.g. `fn AS firstName`) in the list, then the entire list will be passed through unchanged and used in the `SELECT` clause of the query. By default, all column names in tables `JOIN`ed via the `include` argument will be prepended with the singular version of the included table name.</td>
		</tr>
		
		<tr>
			<td>distinct</td>
			<td>boolean</td>
			<td>false</td>
			<td>false</td>
			<td>Whether to add the `DISTINCT` keyword to your `SELECT` clause. Wheels will, when necessary, add this automatically (when using pagination and a `hasMany` association is used in the `include` argument, to name one example).</td>
		</tr>
		
		<tr>
			<td>include</td>
			<td>string</td>
			<td>false</td>
			<td></td>
			<td>Associations that should be included in the query using `INNER` or `LEFT OUTER` joins (which join type that is used depends on how the association has been set up in your model). If all included associations are set on the current model, you can specify them in a list (e.g. `department,addresses,emails`). You can build more complex `include` strings by using parentheses when the association is set on an included model, like `album(artist(genre))`, for example. These complex `include` strings only work when `returnAs` is set to `query` though.</td>
		</tr>
		
		<tr>
			<td>maxRows</td>
			<td>numeric</td>
			<td>false</td>
			<td>-1</td>
			<td>Maximum number of records to retrieve. Passed on to the `maxRows` `cfquery` attribute. The default, `-1`, means that all records will be retrieved.</td>
		</tr>
		
		<tr>
			<td>page</td>
			<td>numeric</td>
			<td>false</td>
			<td>0</td>
			<td>If you want to paginate records, you can do so by specifying a page number here. For example, getting records 11-20 would be page number 2 when `perPage` is kept at the default setting (10 records per page). The default, `0`, means that records won't be paginated and that the `perPage`, `count`, and `handle` arguments will be ignored.</td>
		</tr>
		
		<tr>
			<td>perPage</td>
			<td>numeric</td>
			<td>false</td>
			<td></td>
			<td>When using pagination, you can specify how many records you want to fetch per page here. This argument is only used when the `page` argument has been passed in.</td>
		</tr>
		
		<tr>
			<td>count</td>
			<td>numeric</td>
			<td>false</td>
			<td>0</td>
			<td>When using pagination and you know in advance how many records you want to paginate through, you can pass in that value here. Doing so will prevent Wheels from running a `COUNT` query to get this value. This argument is only used when the `page` argument has been passed in.</td>
		</tr>
		
		<tr>
			<td>handle</td>
			<td>string</td>
			<td>false</td>
			<td>query</td>
			<td>Handle to use for the query in pagination. This is useful when you're paginating multiple queries and need to reference them in the @paginationLinks function, for example. This argument is only used when the `page` argument has been passed in.</td>
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
			<td>Set this to `objects` to return an array of objects. Set this to `query` to return a query result set.</td>
		</tr>
		
		<tr>
			<td>returnIncluded</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>When `returnAs` is set to `objects`, you can set this argument to `false` to prevent returning objects fetched from associations specified in the `include` argument. This is useful when you only need to include associations for use in the `WHERE` clause only and want to avoid the performance hit that comes with object creation.</td>
		</tr>
		
		<tr>
			<td>callbacks</td>
			<td>boolean</td>
			<td>false</td>
			<td>true</td>
			<td>You can set this argument to `false` to prevent running the execution of callbacks for a method call.</td>
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
	
		<!--- Getting only 5 users and ordering them randomly --->
		<cfset fiveRandomUsers = model("user").findAll(maxRows=5, order="random")>

		<!--- Including an association (which in this case needs to be setup as a `belongsTo` association to `author` on the `article` model first)  --->
		<cfset articles = model("article").findAll(where="published=1", order="createdAt DESC", include="author")>

		<!--- Similar to the above but using the association in the opposite direction (which needs to be setup as a `hasMany` association to `article` on the `author` model) --->
		<cfset bobsArticles = model("author").findAll(where="firstName='Bob'", include="articles")>

		<!--- Using pagination (getting records 26-50 in this case) and a more complex way to include associations (a song `belongsTo` an album, which in turn `belongsTo` an artist) --->
		<cfset songs = model("song").findAll(include="album(artist)", page=2, perPage=25)>

		<!--- Using a dynamic finder to get all books released a certain year. Same as calling model("book").findOne(where="releaseYear=#params.year#") --->
		<cfset books = model("book").findAllByReleaseYear(params.year)>

		<!--- Getting all books of a certain type from a specific year by using a dynamic finder. Same as calling model("book").findAll(where="releaseYear=#params.year# AND type='#params.type#'") --->
		<cfset books = model("book").findAllByReleaseYearAndType("#params.year#,#params.type#")>

		<!--- If you have a `hasMany` association setup from `post` to `comment`, you can do a scoped call. (The `comments` method below will call `model("comment").findAll(where="postId=#post.id#")` internally) --->
		<cfset post = model("post").findByKey(params.postId)>
		<cfset comments = post.comments()>
