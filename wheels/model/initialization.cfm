<cfscript>
	/*
	* PRIVATE METHODS
	*/ 	
	
	public any function $initModelClass(required string name, required string path) { 
		variables.wheels = {};
		variables.wheels.errors = [];
		variables.wheels.class = {};
		variables.wheels.class.modelName = arguments.name;
		variables.wheels.class.modelId = Hash(GetMetaData(this).name);
		variables.wheels.class.path = arguments.path;

		// if our name has pathing in it, remove it and add it to the end of of the $class.path variable
		if (Find("/", arguments.name))
		{
			variables.wheels.class.modelName = ListLast(arguments.name, "/");
			variables.wheels.class.path = ListAppend(arguments.path, ListDeleteAt(arguments.name, ListLen(arguments.name, "/"), "/"), "/");
		}

		variables.wheels.class.RESQLAs = "[[:space:]]AS[[:space:]][A-Za-z1-9]+";
		variables.wheels.class.RESQLOperators = "((?:\s+(?:NOT\s+)?LIKE)|(?:\s+(?:NOT\s+)?IN)|(?:\s+IS(?:\s+NOT)?)|(?:<>)|(?:<=)|(?:>=)|(?:!=)|(?:!<)|(?:!>)|=|<|>)";
		variables.wheels.class.RESQLWhere = "\s*(#variables.wheels.class.RESQLOperators#)\s*(\('.+?'\)|\(((?:\+|-)?[0-9\.],?)+\)|'.+?'()|''|((?:\+|-)?[0-9\.]+)()|NULL)((\s*$|\)|\s+(AND|OR)))";
		variables.wheels.class.mapping = {};
		variables.wheels.class.properties = {};
		variables.wheels.class.accessibleProperties = {};
		variables.wheels.class.calculatedProperties = {};
		variables.wheels.class.associations = {};
		variables.wheels.class.callbacks = {};
		variables.wheels.class.keys = "";
		variables.wheels.class.dataSource = application.wheels.dataSourceName;
		variables.wheels.class.username = application.wheels.dataSourceUserName;
		variables.wheels.class.password = application.wheels.dataSourcePassword;
		variables.wheels.class.automaticValidations = application.wheels.automaticValidations;
		setTableNamePrefix(get("tableNamePrefix"));
		table(LCase(pluralize(variables.wheels.class.modelName)));
		local.callbacks = "afterNew,afterFind,afterInitialization,beforeDelete,afterDelete,beforeSave,afterSave,beforeCreate,afterCreate,beforeUpdate,afterUpdate,beforeValidation,afterValidation,beforeValidationOnCreate,afterValidationOnCreate,beforeValidationOnUpdate,afterValidationOnUpdate";
		local.iEnd = ListLen(local.callbacks);
		for (local.i=1; local.i <= local.iEnd; local.i++)
		{
			variables.wheels.class.callbacks[ListGetAt(local.callbacks, local.i)] = ArrayNew(1);
		}
		local.validations = "onSave,onCreate,onUpdate";
		local.iEnd = ListLen(local.validations);
		for (local.i=1; local.i <= local.iEnd; local.i++)
		{
			variables.wheels.class.validations[ListGetAt(local.validations, local.i)] = ArrayNew(1);
		}

		variables.wheels.class.propertyList = "";
		variables.wheels.class.columnList = "";
		variables.wheels.class.calculatedPropertyList = "";

		// run developer's init method if it exists
		if (StructKeyExists(variables, "init"))
		{
			init();
		}
		else if (get("modelRequireInit"))
		{
			$throw(type="Wheels.ModelInitMissing", message="An init function is required for Model: #variables.wheels.class.modelName#", extendedInfo="Create an init function in /models/#variables.wheels.class.modelName#");
		}

		// make sure that the tablename has the respected prefix
		table(getTableNamePrefix() & tableName());

		if (!IsBoolean(variables.wheels.class.tableName) || variables.wheels.class.tableName)
		{
			// load the database adapter
			variables.wheels.class.adapter = $assignAdapter();

			// get columns for the table
			local.columns = variables.wheels.class.adapter.$getColumns(tableName());

			local.processedColumns = "";
			local.iEnd = local.columns.recordCount;
			for (local.i=1; local.i <= local.iEnd; local.i++)
			{
				// set up properties and column mapping
				if (!ListFind(local.processedColumns, local.columns["column_name"][local.i]))
				{
					// default the column to map to a property with the same name
					local.property = local.columns["column_name"][local.i];
					for (local.key in variables.wheels.class.mapping)
					{
						if (StructKeyExists(variables.wheels.class.mapping[local.key], "type") && variables.wheels.class.mapping[local.key].type == "column" && variables.wheels.class.mapping[local.key].value == local.property)
						{
							// developer has chosen to map this column to a property with a different name so set that here
							local.property = local.key;
							break;
						}
					}
					local.type = SpanExcluding(local.columns["type_name"][local.i], "( ");

					// set the info we need for each property
					variables.wheels.class.properties[local.property] = {};
					variables.wheels.class.properties[local.property].dataType = local.type;
					variables.wheels.class.properties[local.property].type = variables.wheels.class.adapter.$getType(local.type, local.columns["decimal_digits"][local.i]);
					variables.wheels.class.properties[local.property].column = local.columns["column_name"][local.i];
					variables.wheels.class.properties[local.property].scale = local.columns["decimal_digits"][local.i];

					// get a boolean value for whether this column can be set to null or not
					// if we don't get a boolean back we try to translate y/n to proper boolean values in cfml (yes/no)
					variables.wheels.class.properties[local.property].nullable = Trim(local.columns["is_nullable"][local.i]);
					if (!IsBoolean(variables.wheels.class.properties[local.property].nullable))
					{
						variables.wheels.class.properties[local.property].nullable = ReplaceList(variables.wheels.class.properties[local.property].nullable, "N,Y", "No,Yes");
					}

					variables.wheels.class.properties[local.property].size = local.columns["column_size"][local.i];
					variables.wheels.class.properties[local.property].label = Humanize(local.property);
					variables.wheels.class.properties[local.property].validationtype = variables.wheels.class.adapter.$getValidationType(variables.wheels.class.properties[local.property].type);
					if (StructKeyExists(variables.wheels.class.mapping, local.property))
					{
						if (StructKeyExists(variables.wheels.class.mapping[local.property], "label"))
						{
							variables.wheels.class.properties[local.property].label = variables.wheels.class.mapping[local.property].label;
						}
						if (StructKeyExists(variables.wheels.class.mapping[local.property], "defaultValue"))
						{
							variables.wheels.class.properties[local.property].defaultValue = variables.wheels.class.mapping[local.property].defaultValue;
						}
					}
					if (local.columns["is_primarykey"][local.i])
					{
						setPrimaryKey(local.property);
					}
					if (variables.wheels.class.automaticValidations && !ListFindNoCase("#application.wheels.timeStampOnCreateProperty#,#application.wheels.timeStampOnUpdateProperty#,#application.wheels.softDeleteProperty#", local.property))
					{
						local.defaultValidationsAllowBlank = variables.wheels.class.properties[local.property].nullable;

						// primary keys should be allowed to be blank
						if (ListFindNoCase(primaryKeys(), local.property))
						{
							local.defaultValidationsAllowBlank = true;
						}
						if (!ListFindNoCase(primaryKeys(), local.property) && !variables.wheels.class.properties[local.property].nullable && !Len(local.columns["column_default_value"][local.i]) && !$validationExists(property=local.property, validation="validatesPresenceOf"))
						{
							validatesPresenceOf(properties=local.property);
						}

						// always allowblank if a database default or validatesPresenceOf() has been set
						if (Len(local.columns["column_default_value"][local.i]) || $validationExists(property=local.property, validation="validatesPresenceOf"))
						{
							local.defaultValidationsAllowBlank = true;
						}

						// set length validations if the developer has not
						if (variables.wheels.class.properties[local.property].validationtype == "string" && !$validationExists(property=local.property, validation="validatesLengthOf"))
						{
							validatesLengthOf(properties=local.property, allowBlank=local.defaultValidationsAllowBlank, maximum=variables.wheels.class.properties[local.property].size);
						}

						// set numericality validations if the developer has not
						if (ListFindNoCase("integer,float", variables.wheels.class.properties[local.property].validationtype) && !$validationExists(property=local.property, validation="validatesNumericalityOf"))
						{
							validatesNumericalityOf(properties=local.property, allowBlank=local.defaultValidationsAllowBlank, onlyInteger=(variables.wheels.class.properties[local.property].validationtype == "integer"));
						}

						// set date validations if the developer has not (checks both dates or times as per the IsDate() function)
						if (variables.wheels.class.properties[local.property].validationtype == "datetime" && !$validationExists(property=local.property, validation="validatesFormatOf"))
						{
							validatesFormatOf(properties=local.property, allowBlank=local.defaultValidationsAllowBlank, type="date");
						}
					}
					variables.wheels.class.propertyList = ListAppend(variables.wheels.class.propertyList, local.property);
					variables.wheels.class.columnList = ListAppend(variables.wheels.class.columnList, variables.wheels.class.properties[local.property].column);
					local.processedColumns = ListAppend(local.processedColumns, local.columns["column_name"][local.i]);
				}
			}
			// raise error when no primary key has been defined for the table
			if (!Len(primaryKeys()))
			{
				$throw(type="Wheels.NoPrimaryKey", message="No primary key exists on the `#tableName()#` table.", extendedInfo="Set an appropriate primary key on the `#tableName()#` table.");
			}
		}

		// add calculated properties
		for (local.key in variables.wheels.class.mapping)
		{
			if (StructKeyExists(variables.wheels.class.mapping[local.key], "type") && variables.wheels.class.mapping[local.key].type != "column")
			{
				variables.wheels.class.calculatedPropertyList = ListAppend(variables.wheels.class.calculatedPropertyList, local.key);
				variables.wheels.class.calculatedProperties[local.key] = {};
				variables.wheels.class.calculatedProperties[local.key][variables.wheels.class.mapping[local.key].type] = variables.wheels.class.mapping[local.key].value;
				variables.wheels.class.calculatedProperties[local.key].select = variables.wheels.class.mapping[local.key].select;
				variables.wheels.class.calculatedProperties[local.key].dataType = variables.wheels.class.mapping[local.key].dataType;
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
		return this;
	}

	public any function $assignAdapter() { 
		if (application.wheels.showErrorInformation)
		{
			try
			{
				local.info = $dbinfo(dataSource=variables.wheels.class.dataSource, username=variables.wheels.class.username, password=variables.wheels.class.password, type="version");
			}
			catch (any e)
			{
				$throw(type="Wheels.DataSourceNotFound", message="The data source could not be reached.", extendedInfo="Make sure your database is reachable and that your data source settings are correct. You either need to setup a data source with the name `#variables.wheels.class.dataSource#` in the Administrator or tell CFWheels to use a different data source in `config/settings.cfm`.");
			}
		}
		else
		{
			local.info = $dbinfo(dataSource=variables.wheels.class.dataSource, username=variables.wheels.class.username, password=variables.wheels.class.password, type="version");
		}
		if (FindNoCase("SQLServer", local.info.driver_name) || FindNoCase("SQL Server", local.info.driver_name))
		{
			local.adapterName = "SQLServer";
		}
		else if (FindNoCase("MySQL", local.info.driver_name))
		{
			local.adapterName = "MySQL";
		}
		else if (FindNoCase("Oracle", local.info.driver_name))
		{
			local.adapterName = "Oracle";
		}
		else if (FindNoCase("PostgreSQL", local.info.driver_name))
		{
			local.adapterName = "PostgreSQL";
		}
		else if (FindNoCase("H2", local.info.driver_name))
		{
			local.adapterName = "H2";
		}
		else
		{
			$throw(type="Wheels.DatabaseNotSupported", message="#local.info.database_productname# is not supported by CFWheels.", extendedInfo="Use SQL Server, MySQL, Oracle, PostgreSQL or H2.");
		}
		local.rv = CreateObject("component", "adapters.#local.adapterName#").init(dataSource=variables.wheels.class.dataSource, username=variables.wheels.class.username, password=variables.wheels.class.password);
		application.wheels.adapterName = local.adapterName; 
		return local.rv;
	}

	public any function $initModelObject(
		required string name,
		required any properties,
		required boolean persisted,
		numeric row="1",
		boolean base="true",
		boolean useFilterLists="true"
	) { 
		variables.wheels = {};
		variables.wheels.instance = {};
		variables.wheels.errors = [];

		// assign an object id for the instance (only use the last 12 digits to avoid creating an exponent)
		request.wheels.tickCountId = Right(request.wheels.tickCountId, 12) + 1;
		variables.wheels.tickCountId = request.wheels.tickCountId;

		// copy class variables from the object in the application scope
		if (!StructKeyExists(variables.wheels, "class"))
		{
			local.lockName = "classLock" & application.applicationName;
			variables.wheels.class = $simpleLock(name=local.lockName, type="readOnly", object=application.wheels.models[arguments.name], execute="$classData");
		}

		// setup object properties in the this scope
		if (IsQuery(arguments.properties) && arguments.properties.recordCount != 0)
		{
			arguments.properties = $queryRowToStruct(argumentCollection=arguments);
		}

		if (IsStruct(arguments.properties) && !StructIsEmpty(arguments.properties))
		{
			$setProperties(properties=arguments.properties, setOnModel=true, $useFilterLists=arguments.useFilterLists);
		}
		if (arguments.persisted)
		{
			$updatePersistedProperties();
		}
		variables.wheels.instance.persistedOnInitialization = arguments.persisted;		 
		return this;
	}

	public struct function $classData() {
		return variables.wheels.class;
	}

	public boolean function $softDeletion() {
		return variables.wheels.class.softDeletion;
	}

	public string function $softDeleteColumn() {
		return variables.wheels.class.softDeleteColumn;
	}
</cfscript>