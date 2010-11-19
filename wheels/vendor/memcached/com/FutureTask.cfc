<cfcomponent extends="_base" output="false">

	<!----------
					Cancel() - returns a boolean - allows you to cancel the operation
					get( int, variables.timeunit ) - returns object - when an interger is sent in, you can 
							get the result in that amount of time.
					get() - returns an object - get the result when it is available.
					isCancelled() -  returns boolean - lets you know if the operation was cancelled
					isDone() - returns boolean - 
	---------->
	<cfset variables._futureTask = "">
	<cfset variables.inited = false>
	
	<cffunction name="init" access="public" output="false" returntype="Any" hint="init func to set the futureTask">
		<cfargument name="myFutureTask" required="true" type="any" 
			hint="this must be a future Task returned by the java memcached client otherwise, this will fail.">
		
		<cfset variables._futureTask = arguments.myFutureTask>
		<cfif isObject(arguments.myFutureTask)>
			<cfset variables.inited = true>
		</cfif>
		<cfset super.init()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="isDone" access="public" output="false" returntype="boolean" 
			hint="returns true when the operation has finished. otherwise it returns false">
		<cfscript>
			var ret = false;
			if (variables.inited )	{
				ret = variables._futureTask.isDone();
			}
			if (not isDefined("ret")) {
				ret = false;
			}	
		</cfscript>
		<cfreturn ret>
	</cffunction>

	<Cffunction name="isCancelled" access="public" output="false" returntype="boolean"
			hint="Returns true if the fetch has been cancelled. false otherwise">
		<cfscript>
			var ret = false;
			if (variables.inited )	{
				ret = variables._futureTask.isCancelled();
			}
			if (not isDefined("ret")) {
				ret = false;
			}	
		</cfscript>
		<cfreturn ret>
	</Cffunction>

	<cffunction name="cancel" access="public" output="false" returntype="boolean" 
			hint="cancels the returning result.">
		<cfscript>
			var ret = false;
			if (variables.inited )	{
				ret = variables._futureTask.cancel();
			}
			if (not isDefined("ret")) {
				ret = false;
			}
		</cfscript>
		<cfreturn ret>
	</cffunction>

	<cffunction name="get" access="public" output="false" returntype="any" 
			hint="Gets the result, when available. if the result is not available, it will return an empty string">
		<cfargument name="timeout" type="numeric" required="false" default="#variables.defaultRequestTimeout#" 
				hint="the number of milliseconds to wait until for the response.  
				a timeout setting of 0 will wait forever for a response from the server"/>
		<cfargument name="timeoutUnit" type="string" required="false" default="#variables.defaultTimeoutUnit#"
				hint="The timeout unit to use for the timeout"/>
		<cfscript>
			var ret = "";
			// gotta go through all this to catch the nulls.
			try	{
				if ( arguments.timeout neq 0 and variables.inited)	{
					ret = variables._futureTask.Get(arguments.timeout, getTimeUnitType(arguments.timeoutUnit));
				} else if (variables.inited ) {
					ret = variables._futureTask.Get();
				}
				// additional processing might be required.
				if (not isdefined("ret"))	{
					ret = "";
				} else {
					ret = deserialize(ret);
				}
			} catch(Any e)	{
				ret = "";
				cancel();
			}
		</cfscript>
		<cfreturn ret/>
	</cffunction> 

</cfcomponent>