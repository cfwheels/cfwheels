# update()

## Description
Updates the object with the supplied properties and saves it to the database. Returns `true` if the object was saved successfully to the database and `false` otherwise.

## Function Syntax
	update( [ properties, parameterize, reload, validate, transaction, callbacks ] )


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
			<td>properties</td>
			<td>struct</td>
			<td>false</td>
			<td>[runtime expression]</td>
			<td>The properties you want to set on the object (can also be passed in as named arguments).</td>
		</tr>
		
		<tr>
			<td>parameterize</td>
			<td>any</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to use `cfqueryparam` on all columns, or pass in a list of property names to use `cfqueryparam` on those only.</td>
		</tr>
		
		<tr>
			<td>reload</td>
			<td>boolean</td>
			<td>false</td>
			<td></td>
			<td>Set to `true` to force Wheels to query the database even though an identical query may have been run in the same request. (The default in Wheels is to get the second query from the request-level cache.)</td>
		</tr>
		
		<tr>
			<td>validate</td>
			<td>boolean</td>
			<td>false</td>
			<td>true</td>
			<td>Set to `false` to skip validations for this operation.</td>
		</tr>
		
		<tr>
			<td>transaction</td>
			<td>string</td>
			<td>false</td>
			<td>[runtime expression]</td>
			<td>Set this to `commit` to update the database when the save has completed, `rollback` to run all the database queries but not commit them, or `none` to skip transaction handling altogether.</td>
		</tr>
		
		<tr>
			<td>callbacks</td>
			<td>boolean</td>
			<td>false</td>
			<td>true</td>
			<td>Set to `false` to disable callbacks for this operation.</td>
		</tr>
		
	</tbody>
</table>


## Examples
	
		<!--- Get a post object and then update its title in the database --->
		<cfset post = model("post").findByKey(33)>
		<cfset post.update(title="New version of Wheels just released")>

		<!--- Get a post object and then update its title and other properties based on what is pased in from the URL/form --->
		<cfset post = model("post").findByKey(params.key)>
		<cfset post.update(title="New version of Wheels just released", properties=params.post)>

		<!--- If you have a `hasOne` association setup from `author` to `bio`, you can do a scoped call. (The `setBio` method below will call `bio.update(authorId=anAuthor.id)` internally.) --->
		<cfset author = model("author").findByKey(params.authorId)>
		<cfset bio = model("bio").findByKey(params.bioId)>
		<cfset author.setBio(bio)>

		<!--- If you have a `hasMany` association setup from `owner` to `car`, you can do a scoped call. (The `addCar` method below will call `car.update(ownerId=anOwner.id)` internally.) --->
		<cfset anOwner = model("owner").findByKey(params.ownerId)>
		<cfset aCar = model("car").findByKey(params.carId)>
		<cfset anOwner.addCar(aCar)>

		<!--- If you have a `hasMany` association setup from `post` to `comment`, you can do a scoped call. (The `removeComment` method below will call `comment.update(postId="")` internally.) --->
		<cfset aPost = model("post").findByKey(params.postId)>
		<cfset aComment = model("comment").findByKey(params.commentId)>
		<cfset aPost.removeComment(aComment)>
