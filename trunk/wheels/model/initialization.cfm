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

<cffunction name="SetSoftDeleteColumn" returntype="void" access="public" output="false" hint="Init, Sets a column to use for soft deletion">
	<cfargument name="name" type="any" required="true" hint="Name of column">
	<cfscript>
		variables.wheels.class.softDeletion = true;
		variables.wheels.class.softDeleteColumn = arguments.column;
	</cfscript>
</cffunction>

<cffunction name="disableSoftDeletion" returntype="void" access="public" output="false" hint="Init, Disables soft deletion completely (overriding database introspection that may have turned on soft deletion)">
	<cfscript>
		variables.wheels.class.softDeletion = false;
		if (StructKeyExists(variables.wheels.class, "softDeleteColumn"))
			StructDelete(variables.wheels.class, "softDeleteColumn");
	</cfscript>
</cffunction>

<cffunction name="SetTimeStampColumns" returntype="void" access="public" output="false" hint="Init, Sets column(s) to use for time stamping records">
	<cfargument name="create" type="string" required="false" default="" hint="Column to use for time stamping on creating new records">
	<cfargument name="update" type="string" required="false" default="" hint="Column to use for time stamping on updating existing records">
	<cfscript>
		if (Len(arguments.create) IS NOT 0)
		{
			variables.wheels.class.timeStampingOnCreate = true;
			variables.wheels.class.timeStampOnCreateColumn = arguments.create;
		}
		if (Len(arguments.update) IS NOT 0)
		{
			variables.wheels.class.timeStampingOnUpdate = true;
			variables.wheels.class.timeStampOnUpdateColumn = arguments.update;
		}
	</cfscript>
</cffunction>

<cffunction name="disableTimeStamping" returntype="void" access="public" output="false" hint="Init, Disables timestamping completely (overriding database introspection that may have turned on timestamping)">
	<cfscript>
		variables.wheels.class.timeStampingOnCreate = true;
		variables.wheels.class.timeStampingOnUpdate = true;
		if (StructKeyExists(variables.wheels.class, "timeStampOnCreateColumn"))
			StructDelete(variables.wheels.class, "timeStampOnCreateColumn");
		if (StructKeyExists(variables.wheels.class, "timeStampOnUpdateColumn"))
			StructDelete(variables.wheels.class, "timeStampOnCreateColumn");
	</cfscript>
</cffunction>

<cffunction name="$initClass" returntype="any" access="public" output="false">
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
		loc.columns = $dbinfo(datasource=application.settings.database.datasource, type="columns", table=variables.wheels.class.tableName);
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

		// setup soft deletion info unless set manually by the developer
		if (!StructKeyExists(variables.wheels.class, "softDeletion"))
		{
			if (StructKeyExists(variables.wheels.class.properties, application.settings.defaultSoftDeleteColumn))
			{
				variables.wheels.class.softDeletion = true;
				variables.wheels.class.softDeleteColumn = application.settings.defaultSoftDeleteColumn;
			}
			else
			{
				variables.wheels.class.softDeletion = false;
			}
		}

		// setup time stamping info unless set manually by the developer
		if (!StructKeyExists(variables.wheels.class, "timeStampingOnCreate"))
		{
			if (StructKeyExists(variables.wheels.class.properties, application.settings.defaultTimeStampOnCreateColumn))
			{
				variables.wheels.class.timeStampingOnCreate = true;
				variables.wheels.class.timeStampOnCreateColumn = application.settings.defaultTimeStampOnCreateColumn;
			}
			else
			{
				variables.wheels.class.timeStampingOnCreate = false;
			}

		}
		if (!StructKeyExists(variables.wheels.class, "timeStampingOnUpdate"))
		{
			if (StructKeyExists(variables.wheels.class.properties, application.settings.defaultTimeStampOnUpdateColumn))
			{
				variables.wheels.class.timeStampingOnUpdate = true;
				variables.wheels.class.timeStampOnUpdateColumn = application.settings.defaultTimeStampOnUpdateColumn;
			}
			else
			{
				variables.wheels.class.timeStampingOnUpdate = false;
			}
		}
	</cfscript>
	<cfreturn this>
</cffunction>