<cffunction name="$initModelClass" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		var loc = {};
		variables.wheels = {};
		variables.wheels.errors = [];
		variables.wheels.class = {};
		variables.wheels.class.name = arguments.name;
		variables.wheels.class.RESQLOperators = "((?: LIKE)|(?:<>)|(?:<=)|(?:>=)|(?:!=)|(?:!<)|(?:!>)|=|<|>)";
		variables.wheels.class.RESQLWhere = "(#variables.wheels.class.RESQLOperators# ?)(''|'.+?'()|(-?[0-9]|\.)+()|\(-?[0-9]+(,-?[0-9]+)*\))(($|\)| (AND|OR)))";  
		variables.wheels.class.mapping = {};
		variables.wheels.class.properties = {};
		variables.wheels.class.calculatedProperties = {};
		variables.wheels.class.associations = {};
		variables.wheels.class.callbacks = {};
		variables.wheels.class.connection = {datasource=application.wheels.dataSourceName, username=application.wheels.dataSourceUserName, password=application.wheels.dataSourcePassword};
		loc.callbacks = "afterNew,afterFind,afterInitialization,beforeDelete,afterDelete,beforeSave,afterSave,beforeCreate,afterCreate,beforeUpdate,afterUpdate,beforeValidation,afterValidation,beforeValidationOnCreate,afterValidationOnCreate,beforeValidationOnUpdate,afterValidationOnUpdate";
		loc.iEnd = ListLen(loc.callbacks);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			variables.wheels.class.callbacks[ListGetAt(loc.callbacks, loc.i)] = ArrayNew(1);
		loc.validations = "onSave,onCreate,onUpdate";
		loc.iEnd = ListLen(loc.validations);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			variables.wheels.class.validations[ListGetAt(loc.validations, loc.i)] = ArrayNew(1);
		
		// run developer's init method if it exists
		if (StructKeyExists(variables, "init"))
			init();

		// load the database adapter
		variables.wheels.class.adapter = $assignAdapter();

		// set the table name unless set manually by the developer
		if (!StructKeyExists(variables.wheels.class, "tableName"))
		{
			variables.wheels.class.tableName = LCase(pluralize(variables.wheels.class.name));
			if (Len(application.wheels.tableNamePrefix))
				variables.wheels.class.tableName = application.wheels.tableNamePrefix & "_" & variables.wheels.class.tableName;
		}

		// introspect the database
		loc.args = {};
		loc.args.datasource = variables.wheels.class.connection.datasource;
		loc.args.username = variables.wheels.class.connection.username;
		loc.args.password = variables.wheels.class.connection.password;
		loc.args.table = variables.wheels.class.tableName;
		loc.args.type = "columns";
		if (application.wheels.showErrorInformation)
		{
			try
			{
				loc.columns = $dbinfo(argumentCollection=loc.args);
			}
			catch (Any e)
			{
				$throw(type="Wheels.TableNotFound", message="The `#variables.wheels.class.tableName#` table could not be found in the database.", extendedInfo="Add a table named `#variables.wheels.class.tableName#` to your database or tell Wheels to use a different table for this model. For example you can tell a `user` model to use a table called `tbl_users` by creating a `User.cfc` file in the `models` folder, creating an `init` method inside it and then calling `table(""tbl_users"")` from within it.");
			}
		}
		else
		{
			loc.columns = $dbinfo(argumentCollection=loc.args);
		}

		variables.wheels.class.keys = "";
		variables.wheels.class.propertyList = "";
		variables.wheels.class.columnList = "";
		loc.processedColumns = "";
		loc.iEnd = loc.columns.recordCount;
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			// set up properties and column mapping
			if (!ListFind(loc.processedColumns, loc.columns["column_name"][loc.i]))
			{
				loc.property = loc.columns["column_name"][loc.i]; // default the column to map to a property with the same name 
				for (loc.key in variables.wheels.class.mapping)
				{
					if (StructKeyExists(variables.wheels.class.mapping[loc.key], "type") && variables.wheels.class.mapping[loc.key].type == "column" && variables.wheels.class.mapping[loc.key].value == loc.property)
					{
						// developer has chosen to map this column to a property with a different name so set that here
						loc.property = loc.key;
						break;
					}
				}
				loc.type = SpanExcluding(loc.columns["type_name"][loc.i], "( ");
				variables.wheels.class.properties[loc.property] = {};
				variables.wheels.class.properties[loc.property].type = variables.wheels.class.adapter.$getType(loc.type);
				variables.wheels.class.properties[loc.property].column = loc.columns["column_name"][loc.i];
				variables.wheels.class.properties[loc.property].scale = loc.columns["decimal_digits"][loc.i];
				loc.defaultValue = loc.columns["column_default_value"][loc.i];
				if ((Left(loc.defaultValue,2) == "((" && Right(loc.defaultValue,2) == "))") || (Left(loc.defaultValue,2) == "('" && Right(loc.defaultValue,2) == "')"))
					loc.defaultValue = Mid(loc.defaultValue, 3, Len(loc.defaultValue)-4);
				else if (Left(loc.defaultValue,1) == "(" && Right(loc.defaultValue,1) == ")")
					loc.defaultValue = Mid(loc.defaultValue, 2, Len(loc.defaultValue)-2);
				variables.wheels.class.properties[loc.property].defaultValue = loc.defaultValue;
				if (loc.columns["is_primarykey"][loc.i])
				{
					variables.wheels.class.keys = ListAppend(variables.wheels.class.keys, loc.property);
				}
				variables.wheels.class.propertyList = ListAppend(variables.wheels.class.propertyList, loc.property);
				variables.wheels.class.columnList = ListAppend(variables.wheels.class.columnList, variables.wheels.class.properties[loc.property].column);
				loc.processedColumns = ListAppend(loc.processedColumns, loc.columns["column_name"][loc.i]);
			}
		}
		if (!Len(variables.wheels.class.keys))
			$throw(type="Wheels.NoPrimaryKey", message="No primary key exists on the `#variables.wheels.class.tableName#` table.", extendedInfo="Set an appropriate primary key on the `#variables.wheels.class.tableName#` table.");

		// add calculated properties
		variables.wheels.class.calculatedPropertyList = "";
		for (loc.key in variables.wheels.class.mapping)
		{
			if (StructKeyExists(variables.wheels.class.mapping[loc.key], "type") && variables.wheels.class.mapping[loc.key].type != "column")
			{
				variables.wheels.class.calculatedPropertyList = ListAppend(variables.wheels.class.calculatedPropertyList, loc.key);
				variables.wheels.class.calculatedProperties[loc.key] = {};
				variables.wheels.class.calculatedProperties[loc.key][variables.wheels.class.mapping[loc.key].type] = variables.wheels.class.mapping[loc.key].value;
			}
		}

		// set up soft deletion and time stamping if the necessary columns in the table exist
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
			variables.wheels.class.timeStampOnCreateProperty = application.wheels.timeStampOnCreateProperty;
		}
		else
		{
			variables.wheels.class.timeStampingOnCreate = false;
		}

		if (Len(application.wheels.timeStampOnUpdateProperty) && StructKeyExists(variables.wheels.class.properties, application.wheels.timeStampOnUpdateProperty))
		{
			variables.wheels.class.timeStampingOnUpdate = true;
			variables.wheels.class.timeStampOnUpdateProperty = application.wheels.timeStampOnUpdateProperty;
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

<cffunction name="$assignAdapter" returntype="any" access="public" output="false">
	<cfscript>
		var loc = {};

		loc.args = {};
		loc.args.datasource = variables.wheels.class.connection.datasource;
		loc.args.username = variables.wheels.class.connection.username;
		loc.args.password = variables.wheels.class.connection.password;
		loc.args.type = "version";
		if (application.wheels.showErrorInformation)
		{
			try
			{
				loc.info = $dbinfo(argumentCollection=loc.args);
			}
			catch (Any e)
			{
				$throw(type="Wheels.DataSourceNotFound", message="The data source could not be reached.", extendedInfo="Make sure your database is reachable and that your data source settings are correct. You either need to setup a data source with the name `#loc.args.datasource#` in the CFML Administrator or tell Wheels to use a different data source in `config/settings.cfm`.");
			}
		}
		else
		{
			loc.info = $dbinfo(argumentCollection=loc.args);
		}

		if (loc.info.driver_name Contains "SQLServer" || loc.info.driver_name Contains "Microsoft SQL Server")
			loc.adapterName = "MicrosoftSQLServer";
		else if (loc.info.driver_name Contains "MySQL")
			loc.adapterName = "MySQL";
		else if (loc.info.driver_name Contains "Oracle")
			loc.adapterName = "Oracle";
		else if (loc.info.driver_name Contains "PostgreSQL")
			loc.adapterName = "PostgreSQL";
		else
			$throw(type="Wheels.DatabaseNotSupported", message="#loc.info.database_productname# is not supported by Wheels.", extendedInfo="Use Microsoft SQL Server, MySQL, Oracle or PostgreSQL.");
		loc.returnValue = CreateObject("component", "adapters.#loc.adapterName#").init(argumentCollection=variables.wheels.class.connection);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$softDeletion" returntype="boolean" access="public" output="false">
	<cfreturn variables.wheels.class.softDeletion>
</cffunction>

<cffunction name="$softDeleteColumn" returntype="string" access="public" output="false">
	<cfreturn variables.wheels.class.softDeleteColumn>
</cffunction>