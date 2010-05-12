<cffunction name="$runTransaction" returntype="any" access="public" output="false" hint="I determine whether a transaction should be run on a specified method on of model.">
	<cfargument name="method" type="string" required="true" hint="Model method to run.">
	<cfargument name="transaction" type="string" required="true" hint="See documentation for @save.">
	<cfargument name="autoRollback" type="boolean" required="false" default="true" hint="I determine whether the transaction should be rolled back automatically.">
	<cfset var loc = {} />
	<cfif not StructKeyExists(variables, arguments.method)>
		<cfif application.wheels.showErrorInformation>
			<cfthrow type="Wheels" message="Model Method not Found!" extendedInfo="The model method `#arguments.method#` does not exist in the model." />
		</cfif>
		<cfreturn false />
	</cfif>
	<cfif $openTransaction(arguments.transaction)>
		<cftransaction action="begin">
			<cfset loc.returnValue = $invoke(componentReference=this, argumentCollection=arguments) />
			<cfif arguments.autoRollback>
				<cfif loc.returnValue>
					<cftransaction action="#arguments.transaction#" />
				<cfelse>
					<cftransaction action="rollback" />
				</cfif>				
			<cfelse>
				<cftransaction action="#arguments.transaction#" />
			</cfif>
		</cftransaction>
		<cfset $closeTransaction()>
	<cfelse>
		<cfset loc.returnValue = $invoke(componentReference=this, argumentCollection=arguments) />
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