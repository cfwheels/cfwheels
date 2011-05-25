<cfcomponent extends="wheelsMapping.Test">

	<cffunction name="setup">
		<cfset application.wheels.transactionMode = "commit">
	</cffunction>

	<cffunction name="teardown">
		<cfset application.wheels.transactionMode = "none">
	</cffunction>

	<cffunction name="test_create_rollbacks_when_callback_returns_false">
		<cfset loc.tag = model("tagFalseCallbacks").create(name="Kermit", description="The Frog")>
		<cfset loc.tag = model("tagFalseCallbacks").findOne(where="name='Kermit'")>
		<cfset assert("loc.tag IS false")>
	</cffunction>

	<cffunction name="test_update_rollbacks_when_callback_returns_false">
		<cfset loc.tag = model("tagFalseCallbacks").findOne(where="description='testdesc'")>
		<cfset loc.tag.update(name="Kermit")>
		<cfset loc.tag = model("tagFalseCallbacks").findOne(where="description='testdesc'")>
		<cfset assert("loc.tag.name IS 'releases'")>
	</cffunction>

	<cffunction name="test_save_rollbacks_when_callback_returns_false">
		<cfset loc.tag = model("tagFalseCallbacks").findOne(where="description='testdesc'")>
		<cfset loc.tag.name = "Kermit">
		<cfset loc.tag.save()>
		<cfset loc.tag = model("tagFalseCallbacks").findOne(where="description='testdesc'")>
		<cfset assert("loc.tag.name IS 'releases'")>
	</cffunction>

	<cffunction name="test_delete_rollbacks_when_callback_returns_false">
		<cfset loc.tag = model("tagFalseCallbacks").findOne(where="description='testdesc'")>
		<cfset loc.tag.delete()>
		<cfset loc.tag = model("tagFalseCallbacks").findOne(where="description='testdesc'")>
		<cfset assert("IsObject(loc.tag)")>
	</cffunction>

	<cffunction name="test_deleteAll_with_instantiate_rollbacks_when_callback_returns_false">
		<cfset model("tagFalseCallbacks").deleteAll(instantiate=true)>
		<cfset loc.results = model("tagFalseCallbacks").findAll()>
		<cfset assert("loc.results.recordcount IS 8")>
	</cffunction>

	<cffunction name="test_updateAll_with_instantiate_rollbacks_when_callback_returns_false">
		<cfset model("tagFalseCallbacks").updateAll(name="Kermit", instantiate=true)>
		<cfset loc.results = model("tagFalseCallbacks").findAll(where="name = 'Kermit'")>
		<cfset assert("loc.results.recordcount IS 0")>
	</cffunction>

	<cffunction name="test_create_with_rollback">
		<cfset loc.tag = model("tag").create(name="Kermit", description="The Frog", transaction="rollback")>
		<cfset loc.tag = model("tag").findOne(where="name='Kermit'")>
		<cfset assert("not IsObject(loc.tag)")>
	</cffunction>

	<cffunction name="test_update_with_rollback">
		<cfset loc.tag = model("tag").findOne(where="description='testdesc'")>
		<cfset loc.tag.update(name="Kermit", transaction="rollback")>
		<cfset loc.tag = model("tag").findOne(where="description='testdesc'")>
		<cfset assert("loc.tag.name IS 'releases'")>
	</cffunction>

	<cffunction name="test_save_with_rollback">
		<cfset loc.tag = model("tag").findOne(where="description='testdesc'")>
		<cfset loc.tag.name = "Kermit">
		<cfset loc.tag.save(transaction="rollback")>
		<cfset loc.tag = model("tag").findOne(where="description='testdesc'")>
		<cfset assert("loc.tag.name IS 'releases'")>
	</cffunction>

	<cffunction name="test_delete_with_rollback">
		<cfset loc.tag = model("tag").findOne(where="description='testdesc'")>
		<cfset loc.tag.delete(transaction="rollback")>
		<cfset loc.tag = model("tag").findOne(where="description='testdesc'")>
		<cfset assert("IsObject(loc.tag)")>
	</cffunction>

	<cffunction name="test_deleteAll_with_rollback">
		<cfset model("tag").deleteAll(instantiate=true, transaction="rollback")>
		<cfset loc.results = model("tag").findAll()>
		<cfset assert("loc.results.recordcount IS 8")>
	</cffunction>

	<cffunction name="test_updateAll_with_rollback">
		<cfset model("tag").updateAll(name="Kermit", instantiate=true, transaction="rollback")>
		<cfset loc.results = model("tag").findAll(where="name = 'Kermit'")>
		<cfset assert("loc.results.recordcount IS 0")>
	</cffunction>

	<cffunction name="test_create_with_transactions_disabled">
		<cftransaction>
			<cfset loc.tag = model("tag").create(name="Kermit", description="The Frog", transaction="none")>
			<cfset loc.tag = model("tag").findOne(where="name='Kermit'")>
			<cfset assert("IsObject(loc.tag)")>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

	<cffunction name="test_update_with_transactions_disabled">
		<cftransaction>
			<cfset loc.tag = model("tag").findOne(where="description='testdesc'")>
			<cfset loc.tag.update(name="Kermit", transaction="none")>
			<cfset loc.tag.reload()>
			<cfset assert("loc.tag.name IS 'Kermit'")>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

	<cffunction name="test_save_with_transactions_disabled">
		<cftransaction>
			<cfset loc.tag = model("tag").findOne(where="description='testdesc'")>
			<cfset loc.tag.name = "Kermit">
			<cfset loc.tag.save(transaction="none")>
			<cfset loc.tag.reload()>
			<cfset assert("loc.tag.name IS 'Kermit'")>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

	<cffunction name="test_delete_with_transactions_disabled">
		<cftransaction>
			<cfset loc.tag = model("tag").findOne(where="description='testdesc'")>
			<cfset loc.tag.delete(transaction="none")>
			<cfset loc.tag = model("tag").findOne(where="description='testdesc'")>
			<cfset assert("not IsObject(loc.tag)")>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

	<cffunction name="test_deleteAll_with_transactions_disabled">
		<cftransaction>
			<cfset model("tag").deleteAll(instantiate=true, transaction="none")>
			<cfset loc.results = model("tag").findAll()>
			<cfset assert("loc.results.recordcount IS 0")>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

	<cffunction name="test_updateAll_with_transactions_disabled">
		<cftransaction>
			<cfset model("tag").updateAll(name="Kermit", instantiate=true, transaction="none")>
			<cfset loc.results = model("tag").findAll(where="name = 'Kermit'")>
			<cfset assert("loc.results.recordcount IS 8")>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

	<cffunction name="test_nested_transaction_within_callback_respect_initial_transaction_mode">
		<cfset loc.postsBefore = model('post').count(reload=true)>
		<cfset loc.tag = model("tagWithDataCallbacks").create(name="Kermit", description="The Frog", transaction="rollback")>
		<cfset loc.postsAfter = model('post').count(reload=true)>
		<cfset assert("IsObject(loc.tag)")>
		<cfset assert("loc.postsBefore eq loc.postsAfter")>
	</cffunction>

	<cffunction name="test_nested_transaction_within_callback_with_transactions_disabled">
 		<cftransaction>
			<cfset loc.tag = model("tagWithDataCallbacks").create(name="Kermit", description="The Frog", transaction="none")>
			<cfset loc.results = model("tag").findAll(where="name = 'Kermit'")>
 			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert("IsObject(loc.tag)")>
		<cfset assert("loc.results.recordcount IS 1")>
	</cffunction>
		
	<cffunction name="test_transaction_closed_after_rollback">
		<cfset loc.hash = model("tag").$hashedConnectionArgs()>
		<cfset loc.tag = model("tagWithDataCallbacks").create(name="Kermit", description="The Frog", transaction="rollback")>
		<cfset assert('request.wheels.transactions[loc.hash] is false')>
	</cffunction>
	
	<cffunction name="test_transaction_closed_after_none">
		<cfset loc.hash = model("tag").$hashedConnectionArgs()>
		<cftransaction>
			<cfset loc.tag = model("tagWithDataCallbacks").create(name="Kermit", description="The Frog", transaction="none")>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset assert('request.wheels.transactions[loc.hash] is false')>
	</cffunction>

	<cffunction name="test_transaction_closed_when_error_raised">
		<cfset loc.hash = model("tag").$hashedConnectionArgs()>
		<cftry>
			<cfset loc.tag = model("tag").create(id="", name="Kermit", description="The Frog", transaction="rollback")>
			<cfcatch type="any"></cfcatch>
		</cftry>
		<cfset assert('request.wheels.transactions[loc.hash] is false')>
	</cffunction>

	<cffunction name="test_rollback_when_error_raised">
		<cfset loc.tag = Duplicate(model("tagWithDataCallbacks").new(name="Kermit", description="The Frog"))>
		<cfset loc.tag.afterSave(methods="crashMe")>
		<cftry>
			<cfset loc.tag.save()>
			<cfcatch>
				<cfset loc.results = model("tag").findAll(where="name = 'Kermit'")>
			</cfcatch>
		</cftry>
		<cfset assert("loc.results.recordcount IS 0")>
	</cffunction>

</cfcomponent>