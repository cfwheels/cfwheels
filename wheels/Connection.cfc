<cfcomponent output="false">
	<cfinclude template="global/cfml.cfm">

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="datasource" type="string" required="true">
		<cfargument name="username" type="string" required="false" default="">
		<cfargument name="password" type="string" required="false" default="">
		<cfscript>
			var loc = {};
			variables.instance.connection = arguments;
			loc.returnValue = $assignAdapter();
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>

	<cffunction name="$assignAdapter" returntype="any" access="public" output="false">
		<cfscript>
			var loc = {};
			loc.args = Duplicate(variables.instance.connection);
			loc.args.type = "version";
			if (application.wheels.showErrorInformation)
			{
				try
				{
					loc.info = $dbinfo(argumentCollection=loc.args);
				}
				catch (any e)
				{
					$throw(type="Wheels.DataSourceNotFound", message="The data source could not be reached.", extendedInfo="Make sure your database is reachable and that your data source settings are correct. You either need to setup a data source with the name `#loc.args.datasource#` in the Administrator or tell CFWheels to use a different data source in `config/settings.cfm`.");
				}
			}
			else
			{
				loc.info = $dbinfo(argumentCollection=loc.args);
			}
			loc.supportedDatabases = "SQL Server, MySQL, Oracle, PostgreSQL, H2";
			loc.iEnd = ListLen(loc.supportedDatabases);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.item = Trim(ListGetAt(loc.supportedDatabases, loc.i));
				loc.adapter = Replace(loc.item, " ", "");
				if (FindNoCase(loc.item, loc.info.driver_name) || FindNoCase(loc.adapter, loc.info.driver_name))
				{
					loc.returnValue = CreateObject("component", "model.adapters.#loc.adapter#").init(argumentCollection=variables.instance.connection);
					break;
				}
			}
			if (application.wheels.showErrorInformation && !StructKeyExists(loc, "returnValue"))
			{
				$throw(type="Wheels.DatabaseNotSupported", message="#loc.info.database_productname# is not supported by CFWheels.", extendedInfo="Supported databases are: #loc.supportedDatabases#.");
			}
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>

	<cfinclude template="plugins/injection.cfm">
</cfcomponent>