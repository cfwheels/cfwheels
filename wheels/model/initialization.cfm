<cffunction name="table" returntype="void" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
	variables.wheels.class.tableName = arguments.name;
	</cfscript>
</cffunction>

<cffunction name="property" returntype="void" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfargument name="column" type="string" required="true">
	<cfscript>
	variables.wheels.class.mapping[arguments.column] = arguments.name;
	</cfscript>
</cffunction>

<cffunction name="$initClass" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		var loc = {};
		variables.wheels = {};
		variables.wheels.class = {};
		variables.wheels.class.name = arguments.name;
		variables.wheels.class.whereRegex = "((=|<>|<|>|<=|>=|!=|!<|!>| LIKE| IN) ?)(''|'.+?'()|([0-9]|\.)+()|\([0-9]+(,[0-9]+)*\))(($|\)| (AND|OR)))";
		variables.wheels.class.mapping = {};
		variables.wheels.class.associations = {};
		variables.wheels.class.callbacks = {};
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

		// set the table name unless set manually by the developer
		if (!StructKeyExists(variables.wheels.class, "tableName"))
		{
			variables.wheels.class.tableName = LCase(pluralize(variables.wheels.class.name));
			if (Len(application.settings.tableNamePrefix))
				variables.wheels.class.tableName = application.settings.tableNamePrefix & "_" & variables.wheels.class.tableName;
		}
		// introspect the database
		try
		{
			loc.columns = $dbinfo(datasource=application.settings.database.datasource, username=application.settings.database.username, password=application.settings.database.password, type="columns", table=variables.wheels.class.tableName);
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
			variables.wheels.class.properties[loc.property] = {};
			variables.wheels.class.properties[loc.property].column = loc.columns["column_name"][loc.i];
			variables.wheels.class.properties[loc.property].typeName = loc.columns["type_name"][loc.i];
			variables.wheels.class.properties[loc.property].nullable = loc.columns["is_nullable"][loc.i];
			variables.wheels.class.properties[loc.property].scale = loc.columns["decimal_digits"][loc.i];
			variables.wheels.class.properties[loc.property].size = loc.columns["column_size"][loc.i];
			variables.wheels.class.properties[loc.property].key = loc.columns["is_primarykey"][loc.i];
			variables.wheels.class.properties[loc.property].type = application.wheels.adapter.getType(SpanExcluding(loc.columns["type_name"][loc.i], " "));
			if (loc.columns["is_primarykey"][loc.i])
			{
				variables.wheels.class.keys = ListAppend(variables.wheels.class.keys, loc.property);
			}
			variables.wheels.class.propertyList = ListAppend(variables.wheels.class.propertyList, loc.property);
			variables.wheels.class.columnList = ListAppend(variables.wheels.class.columnList, variables.wheels.class.properties[loc.property].column);
		}
		if (!Len(variables.wheels.class.keys))
			$throw(type="Wheels.NoPrimaryKey", message="No primary key exists on the '#variables.wheels.class.tableName#' table.", extendedInfo="Set an appropriate primary key (or multiple keys) on the '#variables.wheels.class.tableName#' table.");		

		if (Len(application.settings.softDeleteProperty) && StructKeyExists(variables.wheels.class.properties, application.settings.softDeleteProperty))
		{
			variables.wheels.class.softDeletion = true;
			variables.wheels.class.softDeleteColumn = variables.wheels.class.properties[application.settings.softDeleteProperty].column;
		}
		else
		{
			variables.wheels.class.softDeletion = false;
		}

		if (Len(application.settings.timeStampOnCreateProperty) && StructKeyExists(variables.wheels.class.properties, application.settings.timeStampOnCreateProperty))
		{
			variables.wheels.class.timeStampingOnCreate = true;
			variables.wheels.class.timeStampOnCreateColumn = variables.wheels.class.properties[application.settings.timeStampOnCreateProperty].column;
		}
		else
		{
			variables.wheels.class.timeStampingOnCreate = false;
		}

		if (Len(application.settings.timeStampOnUpdateProperty) && StructKeyExists(variables.wheels.class.properties, application.settings.timeStampOnUpdateProperty))
		{
			variables.wheels.class.timeStampingOnUpdate = true;
			variables.wheels.class.timeStampOnUpdateColumn = variables.wheels.class.properties[application.settings.timeStampOnUpdateProperty].column;
		}
		else
		{
			variables.wheels.class.timeStampingOnUpdate = false;
		}
	</cfscript>
	<cfreturn this>
</cffunction>