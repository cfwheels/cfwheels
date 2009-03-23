<cffunction name="$initModelClass" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		var loc = {};
		variables.wheels = {};
		variables.wheels.class = {};
		variables.wheels.class.name = arguments.name;
		variables.wheels.class.whereRegex = "((=|<>|<|>|<=|>=|!=|!<|!>| LIKE) ?)(''|'.+?'()|([0-9]|\.)+()|\([0-9]+(,[0-9]+)*\))(($|\)| (AND|OR)))";
		variables.wheels.class.mapping = {};
		variables.wheels.class.associations = {};
		variables.wheels.class.callbacks = {};
		variables.wheels.class.connection = {datasource=application.wheels.dataSourceName, username=application.wheels.dataSourceUserName, password=application.wheels.dataSourcePassword};
		loc.callbacks = "beforeDelete,afterDelete,beforeSave,afterSave,beforeCreate,afterCreate,beforeUpdate,afterUpdate,beforeValidation,afterValidation,beforeValidationOnCreate,afterValidationOnCreate,beforeValidationOnUpdate,afterValidationOnUpdate";
		for (loc.i=1; loc.i LTE ListLen(loc.callbacks); loc.i=loc.i+1)
			variables.wheels.class.callbacks[ListGetAt(loc.callbacks, loc.i)] = ArrayNew(1);
		loc.validations = "onSave,onCreate,onUpdate";
		for (loc.i=1; loc.i LTE ListLen(loc.validations); loc.i=loc.i+1)
			variables.wheels.class.validations[ListGetAt(loc.validations, loc.i)] = ArrayNew(1);
		// run developer's init method
		if (StructKeyExists(variables, "init"))
		{
			init();
		}

		variables.wheels.class.adapter = $assignAdpater();

		// set the table name unless set manually by the developer
		if (!StructKeyExists(variables.wheels.class, "tableName"))
		{
			variables.wheels.class.tableName = LCase($pluralize(variables.wheels.class.name));
			if (Len(application.wheels.tableNamePrefix))
				variables.wheels.class.tableName = application.wheels.tableNamePrefix & "_" & variables.wheels.class.tableName;
		}
		// introspect the database
		try
		{
			loc.columns = $dbinfo(datasource=variables.wheels.class.connection.datasource, username=variables.wheels.class.connection.username, password=variables.wheels.class.connection.password, type="columns", table=variables.wheels.class.tableName);
		}
		catch(Any e)
		{
			$throw(type="Wheels.TableNotFound", message="The '#variables.wheels.class.tableName#' table could not be found in the database.", extendedInfo="Add a table named '#variables.wheels.class.tableName#' to your database or if you already have a table you want to use for this model you can tell Wheels to use it with the 'table' method.");
		}
		variables.wheels.class.keys = "";
		variables.wheels.class.propertyList = "";
		variables.wheels.class.columnList = "";
		for (loc.i=1; loc.i LTE loc.columns.recordCount; loc.i=loc.i+1)
		{
			if (StructKeyExists(variables.wheels.class.mapping, loc.columns["column_name"][loc.i]))
				loc.property = variables.wheels.class.mapping[loc.columns["column_name"][loc.i]];
			else
				loc.property = loc.columns["column_name"][loc.i];
			loc.type = SpanExcluding(loc.columns["type_name"][loc.i], "( ");
			variables.wheels.class.properties[loc.property] = {};
			variables.wheels.class.properties[loc.property].type = variables.wheels.class.adapter.getType(loc.type);
			variables.wheels.class.properties[loc.property].column = loc.columns["column_name"][loc.i];
			variables.wheels.class.properties[loc.property].scale = loc.columns["decimal_digits"][loc.i];
			if (loc.columns["is_primarykey"][loc.i])
			{
				variables.wheels.class.keys = ListAppend(variables.wheels.class.keys, loc.property);
			}
			variables.wheels.class.propertyList = ListAppend(variables.wheels.class.propertyList, loc.property);
			variables.wheels.class.columnList = ListAppend(variables.wheels.class.columnList, variables.wheels.class.properties[loc.property].column);
		}
		if (!Len(variables.wheels.class.keys))
			$throw(type="Wheels.NoPrimaryKey", message="No primary key exists on the '#variables.wheels.class.tableName#' table.", extendedInfo="Set an appropriate primary key (or multiple keys) on the '#variables.wheels.class.tableName#' table.");

		if (Len(application.wheels.softDeleteProperty) && StructKeyExists(variables.wheels.class.properties, application.wheels.softDeleteProperty))
		{
			variables.wheels.class.softDeletion = true;
			variables.wheels.class.softDeleteColumn = variables.wheels.class.properties[application.wheels.softDeleteProperty].column;
		}
		else
		{
			variables.wheels.class.softDeletion = false;
		}

		if (Len(application.wheels.timeStampOnCreateProperty) && StructKeyExists(variables.wheels.class.properties, application.wheels.timeStampOnCreateProperty))
		{
			variables.wheels.class.timeStampingOnCreate = true;
			variables.wheels.class.timeStampOnCreateColumn = variables.wheels.class.properties[application.wheels.timeStampOnCreateProperty].column;
		}
		else
		{
			variables.wheels.class.timeStampingOnCreate = false;
		}

		if (Len(application.wheels.timeStampOnUpdateProperty) && StructKeyExists(variables.wheels.class.properties, application.wheels.timeStampOnUpdateProperty))
		{
			variables.wheels.class.timeStampingOnUpdate = true;
			variables.wheels.class.timeStampOnUpdateColumn = variables.wheels.class.properties[application.wheels.timeStampOnUpdateProperty].column;
		}
		else
		{
			variables.wheels.class.timeStampingOnUpdate = false;
		}
	</cfscript>
	<cfreturn this>
</cffunction>

<cffunction name="$classData" returntype="struct" access="public" output="false">
	<cfreturn variables.wheels.class>
</cffunction>

<cffunction name="$assignAdpater" returntype="Any" access="public" output="false">
<cfscript>
try
{
	loc.info = $dbinfo(datasource=variables.wheels.class.connection.datasource, username=variables.wheels.class.connection.username, password=variables.wheels.class.connection.password, type="version");
}
catch(Any e) {}
if (StructKeyExists(loc, "info"))
{
	if (loc.info.driver_name Contains "MySQL")
		loc.adapterName = "MySQL";
	else if (loc.info.driver_name Contains "Oracle")
		loc.adapterName = "Oracle";
	else if (loc.info.driver_name Contains "SQLServer" || loc.info.driver_name Contains "Microsoft SQL Server")
		loc.adapterName = "MicrosoftSQLServer";
	else
		$throw(type="Wheels.NoSupport", message="#loc.info.database_productname# is not supported by Wheels.", extendedInfo="Use Microsoft SQL Server, Oracle or MySQL.");
	return CreateObject("component", "adapters.#loc.adapterName#").init(argumentCollection=variables.wheels.class.connection);
}
</cfscript>
</cffunction>