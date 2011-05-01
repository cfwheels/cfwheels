<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="test_getting_child">
		<cfset loc.author = model("author").findOne(order="id")>
		<cfset loc.dynamicResult = loc.author.profile()>
		<cfset loc.coreResult = model("profile").findOne(where="authorId=#loc.author.id#")>
		<cfset assert("loc.dynamicResult.bio IS loc.coreResult.bio")>
	</cffunction>

	<cffunction name="test_checking_if_child_exist">
		<cfset loc.author = model("author").findOne(order="id")>
		<cfset loc.dynamicResult = loc.author.hasProfile()>
		<cfset loc.coreResult = model("profile").exists(where="authorId=#loc.author.id#")>
		<cfset assert("loc.dynamicResult IS loc.coreResult")>
	</cffunction>

	<cffunction name="test_adding_child_by_setting_foreign_key">
		<cfset loc.author = model("author").findOne(order="id DESC")>
		<cfset loc.profile = model("profile").findOne(order="id")>
		<cftransaction>
			<cfset loc.author.setProfile(profile=loc.profile, transaction="none")>
			<cfset loc.profile.reload()>
			<cftransaction action="rollback" />
		</cftransaction>		
		<cfset assert("loc.author.id IS loc.profile.authorId")>
		<cfset loc.profile.reload()>
		<cftransaction>
			<cfset loc.author.setProfile(key=loc.profile.id, transaction="none")>
			<cfset loc.profile.reload()>
			<cftransaction action="rollback" />
		</cftransaction>		
		<cfset assert("loc.author.id IS loc.profile.authorId")>
		<cfset loc.profile.reload()>
		<cftransaction>
			<cfset model("profile").updateByKey(key=loc.profile.id, authorId=loc.author.id, transaction="none")>
			<cfset loc.profile.reload()>
			<cftransaction action="rollback" />
		</cftransaction>		
		<cfset assert("loc.author.id IS loc.profile.authorId")>
	</cffunction>

	<cffunction name="test_removing_child_by_nullifying_foreign_key">
		<cfset loc.author = model("author").findOne(order="id")>
		<cftransaction>
			<cfset loc.author.removeProfile(transaction="none")>
			<cfset assert("model('profile').findOne().authorId IS ''")>
			<cftransaction action="rollback" />
		</cftransaction>		
		<cftransaction>
			<cfset model("profile").updateOne(authorId="", where="authorId=#loc.author.id#", transaction="none")>
			<cfset assert("model('profile').findOne().authorId IS ''")>
			<cftransaction action="rollback" />
		</cftransaction>		
	</cffunction>

	<cffunction name="test_deleting_child">
		<cfset loc.author = model("author").findOne(order="id")>
		<cfset loc.profileCount = model("profile").count() />
		<cftransaction>
			<cfset loc.author.deleteProfile(transaction="none")>
			<cfset assert("model('profile').count() eq (loc.profileCount - 1)")>
			<cftransaction action="rollback" />
		</cftransaction>		
		<cftransaction>
			<cfset model("profile").deleteOne(where="authorId=#loc.author.id#", transaction="none")>
			<cfset assert("model('profile').count() eq (loc.profileCount - 1)")>
			<cftransaction action="rollback" />
		</cftransaction>		
	</cffunction>

	<cffunction name="test_creating_new_child">
		<cfset loc.author = model("author").findOne(order="id")>
		<cfset loc.newProfile = loc.author.newProfile(dateOfBirth="17/12/1981")>
		<cfset loc.dynamicResult = loc.newProfile.authorId>
		<cfset loc.newProfile = model("profile").new(authorId=loc.author.id, dateOfBirth="17/12/1981")>
		<cfset loc.coreResult = loc.newProfile.authorId>
		<cfset assert("loc.dynamicResult IS loc.coreResult")>
	</cffunction>

	<cffunction name="test_creating_new_child_and_saving_it">
		<cfset loc.author = model("author").findOne(order="id")>
		<cftransaction>
			<cfset loc.newProfile = loc.author.createProfile(dateOfBirth="17/12/1981", transaction="none")>
			<cfset loc.dynamicResult = loc.newProfile.authorId>
			<cftransaction action="rollback" />
		</cftransaction>
		<cftransaction>
			<cfset loc.newProfile = model("profile").create(authorId=loc.author.id, dateOfBirth="17/12/1981", transaction="none")>
			<cfset loc.coreResult = loc.newProfile.authorId>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert("loc.dynamicResult IS loc.coreResult")>
	</cffunction>

	<cffunction name="test_getting_child_with_join_key">
		<cfset loc.obj = model("user").findOne(order="id", include="author")>
		<cfset assert('loc.obj.firstName eq loc.obj.author.firstName')>
	</cffunction>

</cfcomponent>