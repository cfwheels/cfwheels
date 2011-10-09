<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_getting_children">
		<cfset loc.author = model("author").findOne(order="id")>
		<cfset loc.dynamicResult = loc.author.posts()>
		<cfset loc.coreResult = model("post").findAll(where="authorId=#loc.author.id#")>
		<cfset assert("loc.dynamicResult['title'][1] IS loc.coreResult['title'][1]")>
	</cffunction>
	
	<cffunction name="test_getting_children_with_include">
		<cfset loc.author = model("author").findOne(order="id", include="posts")>
		<cfset assert("IsObject(loc.author) && ArrayLen(loc.author.posts) eq 3")>
		<cfset loc.author = model("author").findOne(order="id", include="posts", returnAs="query")>
		<cfset assert("loc.author.recordcount eq 3")>
	</cffunction>

	<cffunction name="test_counting_children">
		<cfset loc.author = model("author").findOne(order="id")>
		<cfset loc.dynamicResult = loc.author.postCount()>
		<cfset loc.coreResult = model("post").count(where="authorId=#loc.author.id#")>
		<cfset assert("loc.dynamicResult IS loc.coreResult")>
	</cffunction>

	<cffunction name="test_checking_if_children_exist">
		<cfset loc.author = model("author").findOne(order="id")>
		<cfset loc.dynamicResult = loc.author.hasPosts()>
		<cfset loc.coreResult = model("post").exists(where="authorId=#loc.author.id#")>
		<cfset assert("loc.dynamicResult IS loc.coreResult")>
	</cffunction>

	<cffunction name="test_getting_one_child">
		<cfset loc.author = model("author").findOne(order="id")>
		<cfset loc.dynamicResult = loc.author.findOnePost()>
		<cfset loc.coreResult = model("post").findOne(where="authorId=#loc.author.id#")>
		<cfset assert("loc.dynamicResult.title IS loc.coreResult.title")>
	</cffunction>

	<cffunction name="test_adding_child_by_setting_foreign_key">
		<cfset loc.author = model("author").findOne(order="id")>
		<cfset loc.post = model("post").findOne(order="id DESC")>
		<cftransaction>
			<cfset loc.author.addPost(post=loc.post, transaction="none")>
			<!--- we need to test if authorId is set on the loc.post object as well and not just in the database! --->
			<cfset loc.post.reload()>
			<cftransaction action="rollback" />
		</cftransaction>		
		<cfset assert("loc.author.id IS loc.post.authorId")>
		<cfset loc.post.reload()>
		<cftransaction>
			<cfset loc.author.addPost(key=loc.post.id, transaction="none")>
			<cfset loc.post.reload()>
			<cftransaction action="rollback" />
		</cftransaction>		
		<cfset assert("loc.author.id IS loc.post.authorId")>
		<cfset loc.post.reload()>
		<cftransaction>
			<cfset model("post").updateByKey(key=loc.post.id, authorId=loc.author.id, transaction="none")>
			<cfset loc.post.reload()>
			<cftransaction action="rollback" />
		</cftransaction>		
		<cfset assert("loc.author.id IS loc.post.authorId")>
	</cffunction>

	<cffunction name="test_removing_child_by_nullifying_foreign_key">
		<cfset loc.author = model("author").findOne(order="id")>
		<cfset loc.post = model("post").findOne(order="id DESC")>
		<cftransaction>
			<cfset loc.author.removePost(post=loc.post, transaction="none")>
			<!--- we need to test if authorId is set to blank on the loc.post object as well and not just in the database! --->
			<cfset loc.post.reload()>
			<cftransaction action="rollback" />
		</cftransaction>		
		<cfset assert("loc.post.authorId IS ''")>
		<cfset loc.post.reload()>
		<cftransaction>
			<cfset loc.author.removePost(key=loc.post.id, transaction="none")>
			<cfset loc.post.reload()>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert("loc.post.authorId IS ''")>
		<cfset loc.post.reload()>
		<cftransaction>
			<cfset model("post").updateByKey(key=loc.post.id, authorId="", transaction="none")>
			<cfset loc.post.reload()>
			<cftransaction action="rollback" />
		</cftransaction>		
		<cfset assert("loc.post.authorId IS ''")>
	</cffunction>

	<cffunction name="test_deleting_child">
		<cfset loc.author = model("author").findOne(order="id")>
		<cfset loc.post = model("post").findOne(order="id DESC")>
		<cftransaction>
			<cfset loc.author.deletePost(post=loc.post, transaction="none")>
			<!--- should we also set loc.post to false here? --->
			<cfset assert("NOT model('post').exists(loc.post.id)")>
			<cftransaction action="rollback" />
		</cftransaction>
		<cftransaction>
			<cfset loc.author.deletePost(key=loc.post.id, transaction="none")>
			<cfset assert("NOT model('post').exists(loc.post.id)")>
			<cftransaction action="rollback" />
		</cftransaction>		
		<cftransaction>
			<cfset model("post").deleteByKey(key=loc.post.id, transaction="none")>
			<cfset assert("NOT model('post').exists(loc.post.id)")>
			<cftransaction action="rollback" />
		</cftransaction>		
	</cffunction>

	<cffunction name="test_removing_all_children_by_nullifying_foreign_keys">
		<cfset loc.author = model("author").findOne(order="id")>
		<cftransaction>
			<cfset loc.author.removeAllPosts(transaction="none")>
			<cfset loc.dynamicResult = loc.author.postCount()>
			<cfset loc.remainingCount = model("post").count()>
			<cftransaction action="rollback" />
		</cftransaction>
		<cftransaction>
			<cfset model("post").updateAll(authorId="", where="authorId=#loc.author.id#", transaction="none")>
			<cfset loc.coreResult = loc.author.postCount()>
			<cftransaction action="rollback" />
		</cftransaction>		
		<cfset assert("loc.dynamicResult IS 0 AND loc.coreResult IS 0 AND loc.remainingCount IS 5")>
	</cffunction>

	<cffunction name="test_deleting_all_children">
		<cfset loc.author = model("author").findOne(order="id")>
		<cftransaction>
			<cfset loc.author.deleteAllPosts(transaction="none")>
			<cfset loc.dynamicResult = loc.author.postCount()>
			<cfset loc.remainingCount = model("post").count()>
			<cftransaction action="rollback" />
		</cftransaction>
		<cftransaction>
			<cfset model("post").deleteAll(where="authorId=#loc.author.id#", transaction="none")>
			<cfset loc.coreResult = loc.author.postCount()>
			<cftransaction action="rollback" />
		</cftransaction>		
		<cfset assert("loc.dynamicResult IS 0 AND loc.coreResult IS 0 AND loc.remainingCount IS 2")>
	</cffunction>

	<cffunction name="test_creating_new_child">
		<cfset loc.author = model("author").findOne(order="id")>
		<cfset loc.newPost = loc.author.newPost(title="New Title")>
		<cfset loc.dynamicResult = loc.newPost.authorId>
		<cfset loc.newPost = model("post").new(authorId=loc.author.id, title="New Title")>
		<cfset loc.coreResult = loc.newPost.authorId>
		<cfset assert("loc.dynamicResult IS loc.coreResult")>
	</cffunction>

	<cffunction name="test_creating_new_child_and_saving_it">
		<cfset loc.author = model("author").findOne(order="id")>
		<cftransaction>
			<cfset loc.newPost = loc.author.createPost(title="New Title", body="New Body", transaction="none")>
			<cfset loc.dynamicResult = loc.newPost.authorId>
			<cftransaction action="rollback" />
		</cftransaction>
		<cftransaction>
			<cfset loc.newPost = model("post").create(authorId=loc.author.id, title="New Title", body="New Body", transaction="none")>
			<cfset loc.coreResult = loc.newPost.authorId>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert("loc.dynamicResult IS loc.coreResult")>
	</cffunction>
	
	<cffunction name="test_dependency_delete">
		<cftransaction>
			<cfset loc.postWithAuthor = model("post").findOne(order="id")>
			<cfset loc.author = model("author").findByKey(key=loc.postWithAuthor.authorId)>
			<cfset loc.author.hasMany(name="posts", dependent="delete")>
			<cfset loc.author.delete()>
			<cfset loc.posts = model("post").findAll(where="authorId=#loc.author.id#")>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert("loc.posts.recordcount eq 0")>
	</cffunction>

	<cffunction name="test_dependency_deleteAll">
		<cftransaction>
			<cfset loc.postWithAuthor = model("post").findOne(order="id")>
			<cfset loc.author = model("author").findByKey(key=loc.postWithAuthor.authorId)>
			<cfset loc.author.hasMany(name="posts", dependent="deleteAll")>
			<cfset loc.author.delete()>
			<cfset loc.posts = model("post").findAll(where="authorId=#loc.author.id#")>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert("loc.posts.recordcount eq 0")>
	</cffunction>

	<cffunction name="test_dependency_removeAll">
		<cftransaction>
			<cfset loc.postWithAuthor = model("post").findOne(order="id")>
			<cfset loc.author = model("author").findByKey(key=loc.postWithAuthor.authorId)>
			<cfset loc.author.hasMany(name="posts", dependent="removeAll")>
			<cfset loc.author.delete()>
			<cfset loc.posts = model("post").findAll(where="authorId=#loc.author.id#")>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert("loc.posts.recordcount eq 0")>
	</cffunction>

	<cffunction name="test_getting_children_with_join_key">
		<cfset loc.obj = model("user").findOne(order="id", include="authors")>
		<cfset assert('loc.obj.firstName eq loc.obj.authors[1].firstName')>
	</cffunction>

	<cffunction name="test_supply_join_statement_directly">
		<cfset loc.obj = model("user").findAll(order="id", include="authorsCustom")>
		<cfset assert('loc.obj.recordcount eq 4')>
	</cffunction>

</cfcomponent>