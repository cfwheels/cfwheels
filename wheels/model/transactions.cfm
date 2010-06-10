<cffunction name="invokeWithTransaction" returntype="any" access="public" output="false" hint="Runs the specified method with a single database transaction"
	examples=
	'
		<!--- this is the method to be run inside a transaction --->
		<cffunction name="tranferFunds" returntype="boolean" output="false">
			<cfargument name="personFrom">
			<cfargument name="personTo">
			<cfargument name="amount">
			<cfif arguments.personFrom.withdraw(arguments.amount) and arguments.personTo.deposit(arguments.amount)>
				<cfreturn true>
			</cfif>
			<cfreturn false>
		</cffunction>
		
		<cfset david = model("Person").findByName("David")>
		<cfset mary = model("Person").findByName("Mary")>
		<cfset invokeWithTransaction(method="transferFunds", personFrom=david, personTo=mary, amount=100)>
	'
	categories="model-class" chapters="transactions" functions="new,create,save,update,updateByKey,updateOne,updateAll,delete,deleteByKey,deleteOne,deleteAll">
	<cfargument name="method" type="string" required="true" hint="Model method to run.">
	<cfargument name="transaction" type="string" required="true" hint="See documentation for @save.">
	<cfargument name="isolation" type="string" default="read_committed" hint="See documentation for @save.">
	<cfset var loc = {} />
	<cfset loc.methodArgs = $setProperties(properties=StructNew(), argumentCollection=arguments, filterList="method,transaction,isolation", setOnModel=false)>
	<cfif not StructKeyExists(variables, arguments.method)>
		<cfif application.wheels.showErrorInformation>
			<cfthrow type="Wheels.IncorrectArguments" message="Model method not found!" extendedInfo="The method `#arguments.method#` does not exist in this model." />
		</cfif>
		<cfreturn false />
	</cfif>
	<cfif $openTransaction(arguments.transaction)>
		<cftransaction action="begin" isolation="#arguments.isolation#">
			<cfset loc.returnValue = $invoke(method=arguments.method, componentReference=this, argumentCollection=loc.methodArgs) />
			<cfif not IsBoolean(loc.returnValue)>
				<cfset $throw(type="Wheels", message="Invalid return type", extendedInfo="Methods invoked using `invokeWithTransaction` must return a boolean value.")>
			</cfif>
			<cfif loc.returnValue>
				<cftransaction action="#arguments.transaction#" />
			<cfelse>
				<cftransaction action="rollback" />
			</cfif>	
		</cftransaction>
		<cfset $closeTransaction()>
	<cfelse>
		<cfset loc.returnValue = $invoke(method=arguments.method, componentReference=this, argumentCollection=loc.methodArgs) />
	</cfif>
	<cfreturn loc.returnValue />
</cffunction>

<cffunction name="$openTransaction" returntype="boolean" access="public" output="false" hint="I check for an existing transaction.">
	<cfargument name="transaction" type="string" required="true" hint="See documentation for @save.">
	<cfscript>
		// check that the supplied transaction argument is valid
		if (!ListFindNoCase("commit,rollback,none", arguments.transaction))
			$throw(type="Wheels", message="Invalid transaction type", extendedInfo="The transaction type of `#arguments.transaction#` is invalid. Please use `commit`, `rollback` or `none`.");
		// create a tracer variable in request scope for the current model's datasource
		if (!StructKeyExists(request.wheels.transactions, $hashedConnectionArgs()))
			request.wheels.transactions[$hashedConnectionArgs()] = false;
		// open a new transaction if the user has requested it and there isn't one already open
		if (ListFindNoCase("commit,rollback", arguments.transaction) and !request.wheels.transactions[$hashedConnectionArgs()])
		{
			request.wheels.transactions[$hashedConnectionArgs()] = true;
			return true;
		}
	</cfscript>
	<cfreturn false />
</cffunction>

<cffunction name="$closeTransaction" returntype="void" access="public" output="false" hint="I check for an existing transaction.">
	<cfset request.wheels.transactions[$hashedConnectionArgs()] = false>
</cffunction>

<cffunction name="$hashedConnectionArgs" returntype="string" access="public" output="false">
	<cfreturn Hash(variables.wheels.class.connection.datasource & variables.wheels.class.connection.username & variables.wheels.class.connection.password)>
</cffunction>