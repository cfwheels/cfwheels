<!--- PUBLIC MODEL CLASS METHODS (MOVE TO GLOBAL?) --->

<cffunction name="invokeWithTransaction" returntype="any" access="public" output="false">
	<cfargument name="method" type="string" required="true">
	<cfargument name="transaction" type="string" default="commit">
	<cfargument name="isolation" type="string" default="read_committed">

	<cfset var loc = {} />

	<cfset loc.methodArgs = $setProperties(properties=StructNew(), argumentCollection=arguments, filterList="method,transaction,isolation", setOnModel=false, $useFilterLists=false)>
	<cfset loc.connectionArgs = this.$hashedConnectionArgs()>
	<cfset loc.closeTransaction = true>

	<cfif not StructKeyExists(variables, arguments.method)>
		<cfset $throw(type="Wheels", message="Model method not found!", extendedInfo="The method `#arguments.method#` does not exist in this model.")>
	</cfif>

	<!--- create the marker for an open transaction if it doesn't already exist --->
	<cfif not StructKeyExists(request.wheels.transactions, loc.connectionArgs)>
		<cfset request.wheels.transactions[loc.connectionArgs] = false>
	</cfif>

	<!--- if a transaction is already marked as open, change the mode to 'alreadyopen', otherwise open one --->
	<cfif request.wheels.transactions[loc.connectionArgs]>
		<cfset arguments.transaction = "alreadyopen">
		<cfset loc.closeTransaction = false>
	<cfelse>
		<cfset request.wheels.transactions[loc.connectionArgs] = true>
	</cfif>

	<!--- run the method --->
	<cfswitch expression="#arguments.transaction#">
		<cfcase value="commit,rollback">
			<cftransaction action="begin" isolation="#arguments.isolation#">
				<cftry>
					<cfset loc.rv = $invoke(method=arguments.method, componentReference=this, invokeArgs=loc.methodArgs)>
					<cfif IsBoolean(loc.rv) and loc.rv>
						<cftransaction action="#arguments.transaction#">
					<cfelse>
						<cftransaction action="rollback">
					</cfif>
					<cfcatch type="any">
						<cftransaction action="rollback">
						<cfset request.wheels.transactions[loc.connectionArgs] = false>
						<cfrethrow />
					</cfcatch>
				</cftry>
			</cftransaction>
		</cfcase>
		<cfcase value="none,alreadyopen">
			<cfset loc.rv = $invoke(method=arguments.method, componentReference=this, invokeArgs=loc.methodArgs)>
		</cfcase>
		<cfdefaultcase>
			<cfset $throw(type="Wheels", message="Invalid transaction type", extendedInfo="The transaction type of `#arguments.transaction#` is invalid. Please use `commit`, `rollback` or `none`.")>
		</cfdefaultcase>
	</cfswitch>

	<cfif loc.closeTransaction>
		<cfset request.wheels.transactions[loc.connectionArgs] = false>
	</cfif>

	<!--- check the return type --->
	<cfif not IsBoolean(loc.rv)>
		<cfset $throw(type="Wheels", message="Invalid return type", extendedInfo="Methods invoked using `invokeWithTransaction` must return a boolean value.")>
	</cfif>

	<cfreturn loc.rv />
</cffunction>

<!--- PRIVATE METHODS --->

<cffunction name="$hashedConnectionArgs" returntype="string" access="public" output="false">
	<cfreturn Hash(variables.wheels.class.connection.datasource & variables.wheels.class.connection.username & variables.wheels.class.connection.password)>
</cffunction>