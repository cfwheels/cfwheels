<cfcomponent output="false">
	<cfinclude template="global/cfml.cfm">

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="datasource" type="string" required="true">
		<cfargument name="username" type="string" required="false" default="">
		<cfargument name="password" type="string" required="false" default="">
		<cfset variables.instance.connection = arguments>
		<cfset variables.instance.info = $setConnectionInfo()>
		<cfreturn this>
	</cffunction>

	<cffunction name="$assignAdapter" returntype="any" access="public" output="false">
		<cfscript>
		var loc = {};
		loc.args = variables.instance.connection;
		loc.args.info = $getConnectionInfo();
		loc.returnValue = CreateObject("component", "model.adapters.#loc.args.info.adapterName#").init(argumentCollection=loc.args);
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>

	<cffunction name="$setConnectionInfo" returntype="struct" access="public" output="false">
		<cfscript>
		var loc = {};

		loc.args = duplicate(variables.instance.connection);
		loc.args.type = "version";

		try
		{
			loc.q = $dbinfo(argumentCollection=loc.args);
		}
		catch (Any e)
		{
			$throw(type="Wheels.DataSourceNotFound", message="The data source could not be reached.", extendedInfo="Make sure your database is reachable and that your data source settings are correct. You either need to setup a data source with the name `#loc.args.datasource#` in the CFML Administrator or tell Wheels to use a different data source in `config/settings.cfm`.");
		}

		loc.info = {};

		if (loc.q.driver_name Contains "SQLServer" || loc.q.driver_name Contains "SQL Server")
		{
			loc.info.adapterName = "MicrosoftSQLServer";
		}
		else if (loc.q.driver_name Contains "MySQL")
		{
			loc.info.adapterName = "MySQL";
		}
		else if (loc.q.driver_name Contains "Oracle")
		{
			loc.info.adapterName = "Oracle";
		}
		else if (loc.q.driver_name Contains "PostgreSQL")
		{
			loc.info.adapterName = "PostgreSQL";
		}
		else if (loc.q.driver_name Contains "H2")
		{
			loc.info.adapterName = "H2";
		}
		else
		{
			$throw(type="Wheels.DatabaseNotSupported", message="#loc.info.database_productname# is not supported by Wheels.", extendedInfo="Use Microsoft SQL Server, MySQL, Oracle, H2 or PostgreSQL.");
		}

		loc.cols = ListToArray(loc.q.ColumnList);
		loc.iEnd = ArrayLen(loc.cols);
		for(loc.i = 1; loc.i lte loc.iEnd; loc.i++)
		{
			loc.col = loc.cols[loc.i];
			loc.info[loc.col] = loc.q[loc.col][1];
		}
		</cfscript>
		<cfreturn loc.info>
	</cffunction>

	<cffunction name="$getConnectionInfo" returntype="struct" access="public" output="false">
		<cfreturn variables.instance.info>
	</cffunction>

</cfcomponent>