<cffunction name="invokeWithTransaction" returntype="any" access="public" output="false" hint="Runs the specified method within a single database transaction."
	examples=
	'
		<!--- This is the method to be run inside a transaction --->
		<cffunction name="tranferFunds" returntype="boolean" output="false">
			<cfargument name="personFrom">
			<cfargument name="personTo">
			<cfargument name="amount">
			<cfif arguments.personFrom.withdraw(arguments.amount) and arguments.personTo.deposit(arguments.amount)>
				<cfreturn true>
			<cfelse>
				<cfreturn false>
			</cfif>
		</cffunction>

		<cfset david = model("Person").findOneByName("David")>
		<cfset mary = model("Person").findOneByName("Mary")>
		<cfset invokeWithTransaction(method="transferFunds", personFrom=david, personTo=mary, amount=100)>
	'
	categories="model-class" chapters="transactions" functions="new,create,save,update,updateByKey,updateOne,updateAll,delete,deleteByKey,deleteOne,deleteAll">
	<cfargument name="method" type="string" required="true" hint="Model method to run.">
	<cfargument name="transaction" type="string" default="commit" hint="See documentation for @save.">
	<cfargument name="isolation" type="string" default="read_committed" hint="Isolation level to be passed through to the `cftransaction` tag. See your CFML engine's documentation for more details about `cftransaction`'s `isolation` attribute.">
	<cfset var loc = {} />
		
	<cfif not StructKeyExists(variables, arguments.method)>
		<cfset $throw(type="Wheels", message="Model method not found!", extendedInfo="The method `#arguments.method#` does not exist in this model.")>
	</cfif>
	
	<cfif not ListFindNoCase("commit,rollback,none", arguments.transaction)>
		<cfset $throw(type="Wheels", message="Invalid transaction type", extendedInfo="The transaction type of `#arguments.transaction#` is invalid. Please use `commit`, `rollback` or `none`.")>
	</cfif>
	
	<cfset loc.methodArgs = $setProperties(properties=StructNew(), argumentCollection=arguments, filterList="method", setOnModel=false, $useFilterLists=false)>
	<cfset loc.connectionArgs = this.$hashedConnectionArgs()>
	
	<!--- create the marker for an open transaction if it doesn't already exist --->
	<cfif not StructKeyExists(request.wheels.transactions, loc.connectionArgs)>
		<!--- 
		the marker for transaction consits of the following parts:
		
		modelId: the id for the model that opened the transaction. made up of the hash of the model name
		transaction: the mode for the transaction
		method: the name of the method that opened the transaction
		 --->
		<cfset request.wheels.transactions[loc.connectionArgs] = {modelId=variables.wheels.class.modelId, transaction=arguments.transaction, method=arguments.method}>
	<cfelse>
		<cfset request.wheels.transactions[loc.connectionArgs].transaction = "none">
	</cfif>

	<cfif ListFindNoCase("commit,rollback", request.wheels.transactions[loc.connectionArgs].transaction)>
		<cfset loc.transaction = request.wheels.transactions[loc.connectionArgs].transaction>
		<!--- run the method ---> 
		<cftransaction action="begin" isolation="#arguments.isolation#">
			<cftry>
				<cfset loc.returnValue = $invoke(method=arguments.method, componentReference=this, invokeArgs=loc.methodArgs)>
				<cfif IsBoolean(loc.returnValue) and loc.returnValue>
					<cftransaction action="#loc.transaction#" />
				<cfelse>
					<cftransaction action="rollback" />
				</cfif>
				<cfcatch type="any">
					<cftransaction action="rollback" />
					<cfset $closeTransaction(force=true)>
					<cfrethrow />
				</cfcatch>
			</cftry>
		</cftransaction>
		
	</cfif>
		
	<cfif not StructKeyExists(loc, "returnValue")>
		<cftry>
			<cfset loc.returnValue = $invoke(method=arguments.method, componentReference=this, invokeArgs=loc.methodArgs)>
			<cfcatch type="any">
				<cfset $closeTransaction(force=true)>
				<cfrethrow />
			</cfcatch>
		</cftry>
	</cfif>

	<!--- check the return type --->
	<cfif not IsBoolean(loc.returnValue)>
		<cfset $throw(type="Wheels", message="Invalid return type", extendedInfo="Methods invoked using `invokeWithTransaction` must return a boolean value.")>
	</cfif>
	
	<cfreturn loc.returnValue />
</cffunction>

<cffunction name="$hashedConnectionArgs" returntype="string" access="public" output="false">
	<cfreturn Hash(variables.wheels.class.connection.datasource & variables.wheels.class.connection.username & variables.wheels.class.connection.password)>
</cffunction>

<cffunction name="$closeTransaction" returntype="void" access="public" output="false">
	<cfargument name="force" type="boolean" required="false" default="false">
	<cfset var loc = {}>
	<cfset loc.connectionArgs = this.$hashedConnectionArgs()>
 	<cfif
		arguments.force OR
		(StructKeyExists(request.wheels.transactions, loc.connectionArgs)
		AND variables.wheels.class.modelId eq request.wheels.transactions[loc.connectionArgs].modelId
		AND arguments.method eq request.wheels.transactions[loc.connectionArgs].method)>
		<cfset StructDelete(request.wheels.transactions, loc.connectionArgs, false)>
	</cfif>
</cffunction>