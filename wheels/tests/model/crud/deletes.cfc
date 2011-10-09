<cfcomponent extends="wheelsMapping.Test">
 
 	<cffunction name="test_delete">
		<cftransaction action="begin">
			<cfset loc.author = model("Author").findOne()>
			<cfset loc.author.delete()>
			<cfset loc.allAuthors = model("Author").findAll()>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.allAuthors.recordcount eq 6')>
	</cffunction>

 	<cffunction name="test_soft_delete">
		<cftransaction action="begin">
			<cfset loc.post = model("Post").findOne()>
			<cfset loc.post.delete()>
			<cfset loc.postsWithoutSoftDeletes = model("Post").findAll()>
			<cfset loc.postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.postsWithoutSoftDeletes.recordcount eq 4 AND loc.postsWithSoftDeletes.recordcount eq 5')>
	</cffunction>

 	<cffunction name="test_permanent_delete">
		<cftransaction action="begin">
			<cfset loc.post = model("Post").findOne()>
			<cfset loc.post.delete(softDelete=false)>
			<cfset loc.postsWithoutSoftDeletes = model("Post").findAll()>
			<cfset loc.postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.postsWithoutSoftDeletes.recordcount eq 4 AND loc.postsWithSoftDeletes.recordcount eq 4')>
	</cffunction>

 	<cffunction name="test_permanent_delete_of_soft_deleted_records">
		<cftransaction action="begin">
			<cfset loc.post = model("Post").findOne()>
			<cfset loc.post.delete()>
			<cfset loc.softDeletedPost = model("Post").findByKey(key=loc.post.id, includeSoftDeletes=true)>
			<cfset loc.softDeletedPost.delete(includeSoftDeletes=true, softDelete=false)>
			<cfset loc.postsWithoutSoftDeletes = model("Post").findAll()>
			<cfset loc.postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.postsWithoutSoftDeletes.recordcount eq 4 AND loc.postsWithSoftDeletes.recordcount eq 4')>
	</cffunction>

 	<cffunction name="test_delete_by_key">
		<cftransaction action="begin">
			<cfset loc.post = model("Author").findOne()>
			<cfset model("Author").deleteByKey(loc.post.id)>
			<cfset loc.allAuthors = model("Author").findAll()>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.allAuthors.recordcount eq 6')>
	</cffunction>

 	<cffunction name="test_soft_delete_by_key">
		<cftransaction action="begin">
			<cfset loc.post = model("Post").findOne()>
			<cfset model("Post").deleteByKey(loc.post.id)>
			<cfset loc.postsWithoutSoftDeletes = model("Post").findAll(includeSoftDeletes=false)>
			<cfset loc.postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.postsWithoutSoftDeletes.recordcount eq 4 AND loc.postsWithSoftDeletes.recordcount eq 5')>
	</cffunction>

 	<cffunction name="test_permanent_delete_by_key">
		<cftransaction action="begin">
			<cfset loc.post = model("Post").findOne()>
			<cfset model("Post").deleteByKey(key=loc.post.id, softDelete=false)>
			<cfset loc.postsWithoutSoftDeletes = model("Post").findAll()>
			<cfset loc.postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.postsWithoutSoftDeletes.recordcount eq 4 AND loc.postsWithSoftDeletes.recordcount eq 4')>
	</cffunction>

 	<cffunction name="test_permanent_delete_by_key_of_soft_deleted_records">
		<cftransaction action="begin">
			<cfset loc.post = model("Post").findOne()>
			<cfset model("Post").deleteOne(where="id=#loc.post.id#")>
			<cfset model("Post").deleteOne(where="id=#loc.post.id#", includeSoftDeletes=true, softDelete=false)>
			<cfset loc.postsWithoutSoftDeletes = model("Post").findAll()>
			<cfset loc.postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.postsWithoutSoftDeletes.recordcount eq 4 AND loc.postsWithSoftDeletes.recordcount eq 4')>
	</cffunction>
 
 	<cffunction name="test_delete_one">
		<cftransaction action="begin">
			<cfset model("Author").deleteOne()>
			<cfset loc.allAuthors = model("Author").findAll()>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.allAuthors.recordcount eq 6')>
	</cffunction>

 	<cffunction name="test_soft_delete_one">
		<cftransaction action="begin">
			<cfset model("Post").deleteOne()>
			<cfset loc.postsWithoutSoftDeletes = model("Post").findAll()>
			<cfset loc.postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.postsWithoutSoftDeletes.recordcount eq 4 AND loc.postsWithSoftDeletes.recordcount eq 5')>
	</cffunction>

 	<cffunction name="test_permanent_delete_one">
		<cftransaction action="begin">
			<cfset model("Post").deleteOne(softDelete=false)>
			<cfset loc.postsWithoutSoftDeletes = model("Post").findAll()>
			<cfset loc.postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.postsWithoutSoftDeletes.recordcount eq 4 AND loc.postsWithSoftDeletes.recordcount eq 4')>
	</cffunction>

 	<cffunction name="test_permanent_delete_one_of_soft_deleted_records">
		<cftransaction action="begin">
			<cfset loc.post = model("Post").findOne()>
			<cfset model("Post").deleteOne(where="id=#loc.post.id#")>
			<cfset model("Post").deleteOne(where="id=#loc.post.id#", includeSoftDeletes=true, softDelete=false)>
			<cfset loc.postsWithoutSoftDeletes = model("Post").findAll()>
			<cfset loc.postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.postsWithoutSoftDeletes.recordcount eq 4 AND loc.postsWithSoftDeletes.recordcount eq 4')>
	</cffunction>

 	<cffunction name="test_delete_all">
		<cftransaction action="begin">
			<cfset model("Author").deleteAll()>
			<cfset loc.allAuthors = model("Author").findAll()>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.allAuthors.recordcount eq 0')>
	</cffunction>

 	<cffunction name="test_soft_delete_all">
		<cftransaction action="begin">
			<cfset model("Post").deleteAll()>
			<cfset loc.postsWithoutSoftDeletes = model("Post").findAll()>
			<cfset loc.postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.postsWithoutSoftDeletes.recordcount eq 0 AND loc.postsWithSoftDeletes.recordcount eq 5')>
	</cffunction>

 	<cffunction name="test_permanent_delete_all">
		<cftransaction action="begin">
			<cfset model("Post").deleteAll(softDelete=false)>
			<cfset loc.postsWithoutSoftDeletes = model("Post").findAll()>
			<cfset loc.postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.postsWithoutSoftDeletes.recordcount eq 0 AND loc.postsWithSoftDeletes.recordcount eq 0')>
	</cffunction>

 	<cffunction name="test_permanent_delete_all_of_soft_deleted_records">
		<cftransaction action="begin">
			<cfset model("Post").deleteAll()>
			<cfset model("Post").deleteAll(includeSoftDeletes=true, softDelete=false)>
			<cfset loc.postsWithoutSoftDeletes = model("Post").findAll()>
			<cfset loc.postsWithSoftDeletes = model("Post").findAll(includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.postsWithoutSoftDeletes.recordcount eq 0 AND loc.postsWithSoftDeletes.recordcount eq 0')>
	</cffunction>

</cfcomponent>