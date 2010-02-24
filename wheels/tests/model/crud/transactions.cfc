<cfcomponent extends="wheelsMapping.test">

	<cfinclude template="/wheelsMapping/global/functions.cfm">
	
	<cffunction name="test_create_rollbacks_when_callback_returns_false">
		<cfset loc.author = model("authorFalseCallbacks").create(firstname="Kermit", lastname="The Frog")>
		<cfset loc.author = model("authorFalseCallbacks").findOne(where="firstname='Kermit'", reload=true)>
		<cfset assert("loc.author IS false")>
	</cffunction>

	<cffunction name="test_update_rollbacks_when_callback_returns_false">
		<cfset loc.author = model("authorFalseCallbacks").findOne(where="lastName='Bellenie'", reload=true)>
		<cfset loc.author.update(firstName="Kermit")>
		<cfset loc.author = model("authorFalseCallbacks").findOne(where="lastName='Bellenie'", reload=true)>
		<cfset assert("loc.author.firstName IS 'Andy'")>
	</cffunction>

	<cffunction name="test_save_rollbacks_when_callback_returns_false">
		<cfset loc.author = model("authorFalseCallbacks").findOne(where="lastName='Bellenie'", reload=true)>
		<cfset loc.author.firstname = "Kermit">
		<cfset loc.author.save()>
		<cfset loc.author = model("authorFalseCallbacks").findOne(where="lastName='Bellenie'", reload=true)>
		<cfset assert("loc.author.firstName IS 'Andy'")>
	</cffunction>

	<cffunction name="test_delete_rollbacks_when_callback_returns_false">
		<cfset loc.author = model("authorFalseCallbacks").findOne(where="lastName='Bellenie'", reload=true)>
		<cfset loc.author.delete()>
		<cfset loc.author = model("authorFalseCallbacks").findOne(where="lastName='Bellenie'", reload=true)>
		<cfset assert("IsObject(loc.author)")>
	</cffunction>

	<cffunction name="test_deleteAll_with_instantiate_rollbacks_when_callback_returns_false">
		<cfset model("authorFalseCallbacks").deleteAll(instantiate=true)>
		<cfset loc.results = model("authorFalseCallbacks").findAll(reload=true)>
		<cfset assert("loc.results.recordcount IS 7")>
	</cffunction>

	<cffunction name="test_updateAll_with_instantiate_rollbacks_when_callback_returns_false">
		<cfset model("authorFalseCallbacks").updateAll(firstname="Kermit", instantiate=true)>
		<cfset loc.results = model("authorFalseCallbacks").findAll(where="firstname = 'Kermit'", reload=true)>
		<cfset assert("loc.results.recordcount IS 0")>
	</cffunction>

	<cffunction name="test_create_with_rollback">
		<cfset loc.author = model("author").create(firstname="Kermit", lastname="The Frog", transaction="rollback")>
		<cfset loc.author = model("author").findOne(where="firstname='Kermit'", reload=true)>
		<cfset assert("not IsObject(loc.author)")>
	</cffunction>

	<cffunction name="test_update_with_rollback">
		<cfset loc.author = model("author").findOne(where="lastName='Bellenie'", reload=true)>
		<cfset loc.author.update(firstName="Kermit", transaction="rollback")>
		<cfset loc.author = model("author").findOne(where="lastName='Bellenie'", reload=true)>
		<cfset assert("loc.author.firstName IS 'Andy'")>
	</cffunction>

	<cffunction name="test_save_with_rollback">
		<cfset loc.author = model("author").findOne(where="lastName='Bellenie'", reload=true)>
		<cfset loc.author.firstname = "Kermit">
		<cfset loc.author.save(transaction="rollback")>
		<cfset loc.author = model("author").findOne(where="lastName='Bellenie'", reload=true)>
		<cfset assert("loc.author.firstName IS 'Andy'")>
	</cffunction>

	<cffunction name="test_delete_with_rollback">
		<cfset loc.author = model("author").findOne(where="lastName='Bellenie'", reload=true)>
		<cfset loc.author.delete(transaction="rollback")>
		<cfset loc.author = model("author").findOne(where="lastName='Bellenie'", reload=true)>
		<cfset assert("IsObject(loc.author)")>
	</cffunction>

	<cffunction name="test_deleteAll_with_rollback">
		<cfset model("author").deleteAll(instantiate=true, transaction="rollback")>
		<cfset loc.results = model("author").findAll(reload=true)>
		<cfset assert("loc.results.recordcount IS 7")>
	</cffunction>

	<cffunction name="test_updateAll_with_rollback">
		<cfset model("author").updateAll(firstname="Kermit", instantiate=true, transaction="rollback")>
		<cfset loc.results = model("author").findAll(where="firstname = 'Kermit'", reload=true)>
		<cfset assert("loc.results.recordcount IS 0")>
	</cffunction>

	<cffunction name="test_create_with_transactions_disabled">
		<cftransaction>
			<cfset loc.author = model("author").create(firstname="Kermit", lastname="The Frog", transaction="none")>
			<cfset loc.author = model("author").findOne(where="firstname='Kermit'", reload=true)>
			<cfset assert("IsObject(loc.author)")>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

	<cffunction name="test_update_with_transactions_disabled">
		<cftransaction>
			<cfset loc.author = model("author").findOne(where="lastName='Bellenie'", reload=true)>
			<cfset loc.author.update(firstName="Kermit", transaction="none")>
			<cfset loc.author.reload()>
			<cfset assert("loc.author.firstName IS 'Kermit'")>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

	<cffunction name="test_save_with_transactions_disabled">
		<cftransaction>
			<cfset loc.author = model("author").findOne(where="lastName='Bellenie'", reload=true)>
			<cfset loc.author.firstname = "Kermit">
			<cfset loc.author.save(transaction="none")>
			<cfset loc.author.reload()>
			<cfset assert("loc.author.firstName IS 'Kermit'")>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

	<cffunction name="test_delete_with_transactions_disabled">
		<cftransaction>
			<cfset loc.author = model("author").findOne(where="lastName='Bellenie'", reload=true)>
			<cfset loc.author.delete(transaction="none")>
			<cfset loc.author = model("author").findOne(where="lastName='Bellenie'", reload=true)>
			<cfset assert("not IsObject(loc.author)")>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

	<cffunction name="test_deleteAll_with_transactions_disabled">
		<cftransaction isolation="read_uncommitted">
			<cfset model("author").deleteAll(instantiate=true, transaction="none")>
			<cfset loc.results = model("author").findAll(reload=true)>
			<cfset assert("loc.results.recordcount IS 0")>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

	<cffunction name="test_updateAll_with_transactions_disabled">
		<cftransaction>
			<cfset model("author").updateAll(firstname="Kermit", instantiate=true, transaction="none")>
			<cfset loc.results = model("author").findAll(where="firstname = 'Kermit'", reload=true)>
			<cfset assert("loc.results.recordcount IS 7")>
			<cftransaction action="rollback" />
		</cftransaction>
	</cffunction>

</cfcomponent>