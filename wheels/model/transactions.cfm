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
		return false;
	</cfscript>
</cffunction>

<cffunction name="$closeTransaction" returntype="void" access="public" output="false" hint="I check for an existing transaction.">
	<cfset request.wheels.transactions[$hashedConnectionArgs()] = false>
</cffunction>

<cffunction name="$hashedConnectionArgs" returntype="string" access="public" output="false">
	<cfreturn Hash(variables.wheels.class.connection.datasource & variables.wheels.class.connection.username & variables.wheels.class.connection.password)>
</cffunction>