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
			if (loc.info.driver_name Contains "SQLServer" || loc.info.driver_name Contains "SQL Server")
			{
				loc.adapterName = "SQLServer";
			}
			else if (loc.info.driver_name Contains "MySQL")
			{
				loc.adapterName = "MySQL";
			}
			else if (loc.info.driver_name Contains "Oracle")
			{
				loc.adapterName = "Oracle";
			}
			else if (loc.info.driver_name Contains "PostgreSQL")
			{
				loc.adapterName = "PostgreSQL";
			}
			else if (loc.info.driver_name Contains "H2")
			{
				loc.adapterName = "H2";
			}
			else
			{
				$throw(type="Wheels.DatabaseNotSupported", message="#loc.info.database_productname# is not supported by CFWheels.", extendedInfo="Use SQL Server, MySQL, Oracle, PostgreSQL or H2.");
			}
			loc.returnValue = CreateObject("component", "model.adapters.#loc.adapterName#").init(argumentCollection=variables.instance.connection);
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>

	<cfinclude template="plugins/injection.cfm">
</cfcomponent>