<cffunction name="$initModelClass" returntype="any" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		var loc = {};
		variables.wheels = {};
		variables.wheels.errors = [];
		variables.wheels.class = {};
		variables.wheels.class.modelName = arguments.name;
		variables.wheels.class.RESQLOperators = "((?: LIKE)|(?:<>)|(?:<=)|(?:>=)|(?:!=)|(?:!<)|(?:!>)|=|<|>)";
		variables.wheels.class.RESQLWhere = "(#variables.wheels.class.RESQLOperators# ?)(''|'.+?'()|(-?[0-9]|\.)+()|\(-?[0-9]+(,-?[0-9]+)*\))(($|\)| (AND|OR)))";
		variables.wheels.class.mapping = {};
		variables.wheels.class.properties = {};
		variables.wheels.class.calculatedProperties = {};
		variables.wheels.class.associations = {};
		variables.wheels.class.callbacks = {};
		variables.wheels.class.connection = {datasource=application.wheels.dataSourceName, username=application.wheels.dataSourceUserName, password=application.wheels.dataSourcePassword};
		variables.wheels.class.setDefaultValidations = application.wheels.setDefaultValidations;

		// set some type settings to help in the model since everything is translated to coldfusion types
		variables.wheels.class.types = {};
		variables.wheels.class.types["numeric"] = "cf_sql_tinyint,cf_sql_smallint,cf_sql_integer,cf_sql_bigint,cf_sql_real,cf_sql_numeric,cf_sql_float,cf_sql_decimal,cf_sql_double";
		variables.wheels.class.types["integer"] = "cf_sql_tinyint,cf_sql_smallint,cf_sql_integer,cf_sql_bigint";
		variables.wheels.class.types["string"] = "cf_sql_char,cf_sql_varchar";

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
		variables.wheels.class.adapter = createobject("component", "wheelsMapping.Connection").init(argumentCollection=variables.wheels.class.connection);

		// set the table name unless set manually by the developer
		if (!StructKeyExists(variables.wheels.class, "tableName"))
		{
			variables.wheels.class.tableName = LCase(pluralize(variables.wheels.class.modelName));
			if (Len(application.wheels.tableNamePrefix))
				variables.wheels.class.tableName = application.wheels.tableNamePrefix & "_" & variables.wheels.class.tableName;
		}

		// get columns for the table
		loc.columns = variables.wheels.class.adapter.$getColumns(variables.wheels.class.tableName);

		variables.wheels.class.keys = "";
		variables.wheels.class.propertyList = "";
		variables.wheels.class.columnList = "";
		loc.iEnd = loc.columns.recordCount;
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			// set up properties and column mapping
			loc.property = loc.columns["column_name"][loc.i]; // default the column to map to a property with the same name
			for (loc.key in variables.wheels.class.mapping)
			{
				if (variables.wheels.class.mapping[loc.key].type == "column" && variables.wheels.class.mapping[loc.key].value == loc.property)
				{
					// developer has chosen to map this column to a property with a different name so set that here
					loc.property = loc.key;
					break;
				}
			}
			loc.type = SpanExcluding(loc.columns["type_name"][loc.i], "( ");

			// set the info we need for each property
			variables.wheels.class.properties[loc.property] = {};
			variables.wheels.class.properties[loc.property].type = variables.wheels.class.adapter.$getType(loc.type);
			variables.wheels.class.properties[loc.property].column = loc.columns["column_name"][loc.i];
			variables.wheels.class.properties[loc.property].scale = loc.columns["decimal_digits"][loc.i];
			variables.wheels.class.properties[loc.property].nullable = trim(loc.columns["is_nullable"][loc.i]);
			variables.wheels.class.properties[loc.property].size = loc.columns["column_size"][loc.i];

			// set the default value
			loc.defaultValue = loc.columns["column_default_value"][loc.i];
			if ((Left(loc.defaultValue,2) == "((" && Right(loc.defaultValue,2) == "))") || (Left(loc.defaultValue,2) == "('" && Right(loc.defaultValue,2) == "')"))
				loc.defaultValue = Mid(loc.defaultValue, 3, Len(loc.defaultValue)-4);
			variables.wheels.class.properties[loc.property].defaultValue = loc.defaultValue;

			if (loc.columns["is_primarykey"][loc.i])
			{
				variables.wheels.class.keys = ListAppend(variables.wheels.class.keys, loc.property);
			}
			else
			{
				if (variables.wheels.class.setDefaultValidations) {
					// set nullable validations if the developer has not
					if (!variables.wheels.class.properties[loc.property].nullable and !Len(variables.wheels.class.properties[loc.property].defaultValue) and !$validationExists(property=loc.property, validation="validatesPresenceOf"))
						validatesPresenceOf(properties=loc.property);

					// set length validations if the developer has not
					if (ListFindNoCase(variables.wheels.class.types["string"], variables.wheels.class.properties[loc.property].type) and !$validationExists(property=loc.property, validation="validatesLengthOf"))
						validatesLengthOf(properties=loc.property, allowBlank=variables.wheels.class.properties[loc.property].nullable, maximum=variables.wheels.class.properties[loc.property].size);

					// set numericality validations if the developer has not
					if (ListFindNoCase(variables.wheels.class.types["numeric"], variables.wheels.class.properties[loc.property].type) and !$validationExists(property=loc.property, validation="validatesNumericalityOf"))
						validatesNumericalityOf(properties=loc.property, allowBlank=variables.wheels.class.properties[loc.property].nullable, onlyInteger=ListFindNoCase(variables.wheels.class.types["integer"], variables.wheels.class.properties[loc.property].type));
				}
			}

			variables.wheels.class.propertyList = ListAppend(variables.wheels.class.propertyList, loc.property);
			variables.wheels.class.columnList = ListAppend(variables.wheels.class.columnList, variables.wheels.class.properties[loc.property].column);
		}

		if (!Len(variables.wheels.class.keys))
			$throw(type="Wheels.NoPrimaryKey", message="No primary key exists on the `#variables.wheels.class.tableName#` table.", extendedInfo="Set an appropriate primary key on the `#variables.wheels.class.tableName#` table.");

		// add calculated properties
		variables.wheels.class.calculatedPropertyList = "";
		for (loc.key in variables.wheels.class.mapping)
		{
			if (variables.wheels.class.mapping[loc.key].type != "column")
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

<cffunction name="$softDeletion" returntype="boolean" access="public" output="false">
	<cfreturn variables.wheels.class.softDeletion>
</cffunction>

<cffunction name="$softDeleteColumn" returntype="string" access="public" output="false">
	<cfreturn variables.wheels.class.softDeleteColumn>
</cffunction>