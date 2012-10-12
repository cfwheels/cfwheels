<cfcomponent extends="wheelsMapping.Test">

 	<cffunction name="test_update">
		<cftransaction action="begin">
			<cfset loc.author = model("Author").findOne()>
			<cfset loc.author.update(firstName="Kermit", lastName="Frog")>
			<cfset loc.allKermits = model("Author").findAll(where="firstName='Kermit' AND lastName='Frog'")>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.allKermits.recordcount eq 1')>
	</cffunction>

 	<cffunction name="test_dynamic_update_with_named_argument">
		<cftransaction action="begin">
			<cfset loc.author = model("author").findOne(where="firstName='Andy'")>
			<cfset loc.profile = model("profile").findOne(where="bio LIKE 'ColdFusion Developer'")>
			<cfset loc.author.setProfile(profile=loc.profile)>
			<cfset loc.updatedProfile = model("profile").findByKey(loc.profile.id)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert("loc.updatedProfile.authorId IS loc.author.id")>
	</cffunction>

 	<cffunction name="test_dynamic_update_with_unnamed_argument">
		<cftransaction action="begin">
			<cfset loc.author = model("author").findOne(where="firstName='Andy'")>
			<cfset loc.profile = model("profile").findOne(where="bio LIKE 'ColdFusion Developer'")>
			<cfset loc.author.setProfile(loc.profile)>
			<cfset loc.updatedProfile = model("profile").findByKey(loc.profile.id)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert("loc.updatedProfile.authorId IS loc.author.id")>
	</cffunction>

 	<cffunction name="test_update_one">
		<cftransaction action="begin">
			<cfset model("Author").updateOne(where="firstName='Andy'", firstName="Kermit", lastName="Frog")>
			<cfset loc.allKermits = model("Author").findAll(where="firstName='Kermit' AND lastName='Frog'")>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.allKermits.recordcount eq 1')>
	</cffunction>

 	<cffunction name="test_update_one_for_soft_deleted_records">
		<cftransaction action="begin">
			<cfset loc.post = model("Post").deleteOne(where="views=0")>
			<cfset model("Post").updateOne(where="views=0", title="This is a new title", includeSoftDeletes=true)>
			<cfset loc.changedPosts = model("Post").findAll(where="title='This is a new title'", includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.changedPosts.recordcount eq 1')>
	</cffunction>

 	<cffunction name="test_update_by_key">
		<cftransaction action="begin">
			<cfset loc.author = model("Author").findOne()>
			<cfset model("Author").updateByKey(key=loc.author.id, firstName="Kermit", lastName="Frog")>
			<cfset loc.allKermits = model("Author").findAll(where="firstName='Kermit' AND lastName='Frog'")>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.allKermits.recordcount eq 1')>
	</cffunction>

 	<cffunction name="test_update_by_key_for_soft_deleted_records">
		<cftransaction action="begin">
			<cfset loc.post = model("Post").findOne(where="views=0")>
			<cfset model("Post").updateByKey(key=loc.post.id, title="This is a new title", includeSoftDeletes=true)>
			<cfset loc.changedPosts = model("Post").findAll(where="title='This is a new title'", includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.changedPosts.recordcount eq 1')>
	</cffunction>

 	<cffunction name="test_update_all">
		<cftransaction action="begin">
			<cfset model("Author").updateAll(firstName="Kermit", lastName="Frog")>
			<cfset loc.allKermits = model("Author").findAll(where="firstName='Kermit' AND lastName='Frog'")>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.allKermits.recordcount eq 7')>
	</cffunction>

 	<cffunction name="test_update_all_for_soft_deleted_records">
		<cftransaction action="begin">
			<cfset model("Post").updateAll(title="This is a new title", includeSoftDeletes=true)>
			<cfset loc.changedPosts = model("Post").findAll(where="title='This is a new title'", includeSoftDeletes=true)>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('loc.changedPosts.recordcount eq 5')>
	</cffunction>

   	<cffunction name="test_columns_that_are_not_null_should_allow_for_blank_string_during_update">
		<cftransaction action="begin">
			<cfif application.wheels.dataAdapter eq "Oracle">
				<cfset loc.author = model("author").findOne(where="firstName='Tony'")>
				<cfset loc.author.lastName = " ">
				<cfset loc.author.save()>
				<cfset loc.author = model("author").findOne(where="firstName='Tony'")>	
			<cfelse>
				<cfset loc.author = model("author").findOne(where="firstName='Tony'")>
				<cfset loc.author.lastName = "">
				<cfset loc.author.save()>
				<cfset loc.author = model("author").findOne(where="firstName='Tony'")>		
			</cfif>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfif application.wheels.dataAdapter eq "Oracle">
			<cfset assert("IsObject(loc.author) AND !len(trim(loc.author.lastName))")>
		<cfelse>
			<cfset assert("IsObject(loc.author) AND !len(loc.author.lastName)")>
		</cfif>
	</cffunction>

</cfcomponent>