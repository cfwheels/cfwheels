<cffunction name="columnNames" returntype="string" access="public" output="false"
	hint="Returns a list of column names in the table mapped to this model. The list is ordered according to the columns ordinal position in the database table."
	examples=
	'
		<!--- Get a list of all the column names in the table mapped to the author model --->
		<cfset columns = model("author").columnNames()>
	'
	categories="model-class" chapters="object-relational-mapping" functions="dataSource,property,propertyNames,table,tableName">
	<cfreturn variables.wheels.class.columnList>
</cffunction>

<cffunction name="dataSource" returntype="void" access="public" output="false"
	hint="Use this method to override the data source connection information for this model."
	examples=
	'
		<!--- In models/User.cfc --->
		<cffunction name="init">
			<!--- Tell Wheels to use the data source named `users_source` instead of the default one whenever this model makes SQL calls  --->
  			<cfset dataSource("users_source")>
		</cffunction>
	'
	categories="model-initialization" chapters="object-relational-mapping" functions="columnNames,property,propertyNames,table,tableName">
	<cfargument name="datasource" type="string" required="true" hint="The data source name to connect to.">
	<cfargument name="username" type="string" required="false" default="" hint="The username for the data source.">
	<cfargument name="password" type="string" required="false" default="" hint="The password for the data source.">
	<cfscript>
		StructAppend(variables.wheels.class.connection, arguments, true);
	</cfscript>
</cffunction>

<cffunction name="setProperties" returntype="void" access="public" output="false"
	hint="Allows you to set all the properties at once by passing in a structure with keys matching the property names."
	examples=
	'
		<!--- update the properties of the model with the params struct containing the values of a form post --->
		<cfset user = model("user").new(params)>
		<cfset user.setProperties(params)>
	'	
	categories="model-object" chapters="" functions="properties">
	<cfargument name="properties" type="struct" required="false" default="#structnew()#">
	<cfscript>
		var loc = {};
		for (loc.key in arguments)
			if (loc.key != "properties")
				arguments.properties[loc.key] = arguments[loc.key];
		for (loc.key in arguments.properties)
			this[loc.key] = arguments.properties[loc.key];
	</cfscript>
</cffunction>

<cffunction name="properties" returntype="struct" access="public" output="false"
	hint="Returns a structure of all the properties with their names as keys and the values of the property as values."
	example=
	'
		<!--- Get a structure of all the properties for a given model --->
		<cfset user = model("user").new()>
		<cfset user.properties()>
		
	'		
	categories="model-object" chapters="" functions="setProperties">	
	<cfscript>
		var loc = {};
		loc.returnValue = {};
		
		// loop through all properties and functions in the this scope
		for (loc.key in this)
		{
			// we return anything that is not a function
			if (!IsCustomFunction(this[loc.key]))
			{
				// try to get the property name from the list set on the object, this is just to avoid returning everything in ugly upper case which Adobe ColdFusion does by default
				if (ListFindNoCase(propertyNames(), loc.key))
					loc.key = ListGetAt(propertyNames(), ListFindNoCase(propertyNames(), loc.key));

				// set property from the this scope in the struct that we will return
				loc.returnValue[loc.key] = this[loc.key];
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="property" returntype="void" access="public" output="false"
	hint="Use this method to map an object property to either a table column with a different name than the property or to a specific SQL function. You only need to use this method when you want to override the default mapping that Wheels performs."
	examples=
	'
		<!--- In models/User.cfc --->
		<cffunction name="init">
			<!--- Tell Wheels that when we are referring to `firstName` in the CFML code it should translate to the `STR_USERS_FNAME` column when interacting with the database instead of the default (which would be the `firstname` column) --->
  			<cfset property(name="firstName", column="STR_USERS_FNAME")>
		</cffunction>
	'
	categories="model-initialization" chapters="object-relational-mapping" functions="columnNames,dataSource,propertyNames,table,tableName">
	<cfargument name="name" type="string" required="true" hint="The name that you want to use for the column or SQL function result in the CFML code.">
	<cfargument name="column" type="string" required="false" default="" hint="The name of the column in the database table to map the property to.">
	<cfargument name="sql" type="string" required="false" default="" hint="An SQL function to use to calculate the property value.">
	<cfscript>
		variables.wheels.class.mapping[arguments.name] = {};
		if (Len(arguments.column))
		{
			variables.wheels.class.mapping[arguments.name].type = "column";
			variables.wheels.class.mapping[arguments.name].value = arguments.column;
		}
		else if (Len(arguments.sql))
		{
			variables.wheels.class.mapping[arguments.name].type = "sql";
			variables.wheels.class.mapping[arguments.name].value = arguments.sql;
		}
	</cfscript>
</cffunction>

<cffunction name="propertyNames" returntype="string" access="public" output="false"
	hint="Returns a list of property names (ordered by their respective column's ordinal position in the database table)."
	examples=
	'
		<!--- Get a list of the property names in use in the user model --->
  		<cfset propNames = model("user").propertyNames()>
	'
	categories="model-class" chapters="object-relational-mapping" functions="columnNames,dataSource,property,table,tableName">
	<cfscript>
		var loc = {};
		loc.returnValue = variables.wheels.class.propertyList;
		if (ListLen(variables.wheels.class.calculatedPropertyList))
			loc.returnValue = ListAppend(loc.returnValue, variables.wheels.class.calculatedPropertyList);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="table" returntype="void" access="public" output="false"
	hint="Use this method to tell Wheels what database table to connect to for this model. You only need to use this method when your table naming does not follow the standard Wheels convention of a singular object name mapping to a plural table name."
	examples=
	'
		<!--- In models/User.cfc --->
		<cffunction name="init">
			<!--- Tell Wheels to use the `tbl_USERS` table in the database for the `user` model instead of the default (which would be `users`) --->
			<cfset table("tbl_USERS")>
		</cffunction>
	'
	categories="model-initialization" chapters="object-relational-mapping" functions="columnNames,dataSource,property,propertyNames,tableName">
	<cfargument name="name" type="string" required="true" hint="Name of the table to map this model to.">
	<cfscript>
		variables.wheels.class.tableName = arguments.name;
	</cfscript>
</cffunction>

<cffunction name="tableName" returntype="string" access="public" output="false"
	hint="Returns the name of the database table that this model is mapped to."
	examples=
	'
		<!--- Check what table the user model uses --->
		<cfset whatAmIMappedTo = model("user").tableName()>
	'
	categories="model-class" chapters="object-relational-mapping" functions="columnNames,dataSource,property,propertyNames,table">
	<cfreturn variables.wheels.class.tableName>
</cffunction>

<cffunction name="onMissingMethod" returntype="any" access="public" output="false" hint="This method handles dynamic finders, property and association methods. It is not part of the public API.">
	<cfargument name="missingMethodName" type="string" required="true">
	<cfargument name="missingMethodArguments" type="struct" required="true">
	<cfscript>
		var loc = {};
		if (Right(arguments.missingMethodName, 10) == "hasChanged")
			loc.returnValue = hasChanged(property=ReplaceNoCase(arguments.missingMethodName, "hasChanged", ""));
		else if (Right(arguments.missingMethodName, 11) == "changedFrom")
			loc.returnValue = changedFrom(property=ReplaceNoCase(arguments.missingMethodName, "changedFrom", ""));
		else if (Left(arguments.missingMethodName, 9) == "findOneBy" || Left(arguments.missingMethodName, 9) == "findAllBy")
		{
			if (StructKeyExists(server, "railo"))
				loc.finderProperties = ListToArray(LCase(ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(arguments.missingMethodName, "And", "|"), "findAllBy", ""), "findOneBy", "")), "|"); // since Railo passes in the method name in all upper case we have to do this here
			else
				loc.finderProperties = ListToArray(ReplaceNoCase(ReplaceNoCase(Replace(arguments.missingMethodName, "And", "|"), "findAllBy", ""), "findOneBy", ""), "|");
			loc.firstProperty = loc.finderProperties[1];
			loc.secondProperty = IIf(ArrayLen(loc.finderProperties) == 2, "loc.finderProperties[2]", "");

			// throw an error when more than one argument is passed in but not `value` (for single property) or `values` (for multiple properties)
			// this means that model("artist").findOneByName("U2") will still work but not model("artist").findOneByName(values="U2", returnAs="query"), need to pass in just `value` there instead.
			if (application.wheels.showDebugInformation)
			{
				if (StructCount(arguments.missingMethodArguments) gt 1)
				{
					if (Len(loc.secondProperty))
					{
						if (!StructKeyExists(arguments.missingMethodArguments, "values"))
							$throw(type="Wheels.IncorrectArguments", message="The `values` argument is required but was not passed in.", extendedInfo="Pass in a list of values to the dynamic finder in the `values` argument.");
					}
					else
					{
						if (!StructKeyExists(arguments.missingMethodArguments, "value"))
							$throw(type="Wheels.IncorrectArguments", message="The `value` argument is required but was not passed in.", extendedInfo="Pass in a value to the dynamic finder in the `value` argument.");
					}
				}
			}

			if (StructCount(arguments.missingMethodArguments) == 1)
				loc.firstValue = Trim(ListFirst(arguments.missingMethodArguments[1]));
			else if (StructKeyExists(arguments.missingMethodArguments, "value"))
				loc.firstValue = arguments.missingMethodArguments.value;
			else if (StructKeyExists(arguments.missingMethodArguments, "values"))
				loc.firstValue = Trim(ListFirst(arguments.missingMethodArguments.values));
			loc.addToWhere = "#loc.firstProperty# = '#loc.firstValue#'";
			if (Len(loc.secondProperty))
			{
				if (StructCount(arguments.missingMethodArguments) == 1)
					loc.secondValue = Trim(ListLast(arguments.missingMethodArguments[1]));
				else if (StructKeyExists(arguments.missingMethodArguments, "values"))
					loc.secondValue = Trim(ListLast(arguments.missingMethodArguments.values));
				loc.addToWhere = loc.addToWhere & " AND #loc.secondProperty# = '#loc.secondValue#'";
			}
			arguments.missingMethodArguments.where = IIf(StructKeyExists(arguments.missingMethodArguments, "where"), "'(' & arguments.missingMethodArguments.where & ') AND (' & loc.addToWhere & ')'", "loc.addToWhere");
			StructDelete(arguments.missingMethodArguments, "1");
			StructDelete(arguments.missingMethodArguments, "value");
			StructDelete(arguments.missingMethodArguments, "values");
			loc.returnValue = IIf(Left(arguments.missingMethodName, 9) == "findOneBy", "findOne(argumentCollection=arguments.missingMethodArguments)", "findAll(argumentCollection=arguments.missingMethodArguments)");
		}
		else
		{
			for (loc.key in variables.wheels.class.associations)
			{
				loc.method = "";
				if (StructKeyExists(variables.wheels.class.associations[loc.key], "shortcut") && arguments.missingMethodName == variables.wheels.class.associations[loc.key].shortcut)
				{
					loc.method = "findAll";
					loc.joinAssociation = $expandedAssociations(include=loc.key);
					loc.joinAssociation = loc.joinAssociation[1];
					loc.joinClass = loc.joinAssociation.class;
					loc.info = model(loc.joinClass).$expandedAssociations(include=ListFirst(variables.wheels.class.associations[loc.key].through));
					loc.info = loc.info[1];
					loc.include = ListLast(variables.wheels.class.associations[loc.key].through);
					if (StructKeyExists(arguments.missingMethodArguments, "include"))
						loc.include = "#loc.include#(#arguments.missingMethodArguments.include#)";
					arguments.missingMethodArguments.include = loc.include;
					loc.where = $keyWhereString(properties=loc.joinAssociation.foreignKey, keys=variables.wheels.class.keys);
					if (StructKeyExists(arguments.missingMethodArguments, "where"))
						loc.where = "(#loc.where#) AND (#arguments.missingMethodArguments.where#)";
					arguments.missingMethodArguments.where = loc.where;
					if (!StructKeyExists(arguments.missingMethodArguments, "returnIncluded"))
						arguments.missingMethodArguments.returnIncluded = false;
				}
				else if (ListFindNoCase(variables.wheels.class.associations[loc.key].methods, arguments.missingMethodName))
				{
					loc.info = $expandedAssociations(include=loc.key);
					loc.info = loc.info[1];
					if (loc.info.type == "hasOne")
					{
						loc.where = $keyWhereString(properties=loc.info.foreignKey, keys=variables.wheels.class.keys);
						if (StructKeyExists(arguments.missingMethodArguments, "where"))
							loc.where = "(#loc.where#) AND (#arguments.missingMethodArguments.where#)";
						loc.name = ReplaceNoCase(arguments.missingMethodName, loc.key, "object"); // create a generic method name (example: "hasProfile" becomes "hasObject")
						if (loc.name == "object")
						{
							loc.method = "findOne";
							arguments.missingMethodArguments.where = loc.where;
						}
						else if (loc.name == "hasObject")
						{
							loc.method = "exists";
							arguments.missingMethodArguments.where = loc.where;
						}
						else if (loc.name == "newObject")
						{
							loc.method = "new";
							$setForeignKeyValues(missingMethodArguments=arguments.missingMethodArguments, keys=loc.info.foreignKey);
						}
						else if (loc.name == "createObject")
						{
							loc.method = "create";
							$setForeignKeyValues(missingMethodArguments=arguments.missingMethodArguments, keys=loc.info.foreignKey);
						}
						else if (loc.name == "removeObject")
						{
							loc.method = "updateOne";
							arguments.missingMethodArguments.where = loc.where;
							$setForeignKeyValues(missingMethodArguments=arguments.missingMethodArguments, keys=loc.info.foreignKey, setToNull=true);
						}
						else if (loc.name == "deleteObject")
						{
							loc.method = "deleteOne";
							arguments.missingMethodArguments.where = loc.where;
						}
						else if (loc.name == "setObject")
						{
							loc.method = "updateByKey";
							$setForeignKeyValues(missingMethodArguments=arguments.missingMethodArguments, keys=loc.info.foreignKey);
							$setObjectOrNumberToKey(arguments.missingMethodArguments);
						}
					}
					else if (loc.info.type == "hasMany")
					{
						loc.where = $keyWhereString(properties=loc.info.foreignKey, keys=variables.wheels.class.keys);
						if (StructKeyExists(arguments.missingMethodArguments, "where"))
							loc.where = "(#loc.where#) AND (#arguments.missingMethodArguments.where#)";
						loc.name = ReplaceNoCase(ReplaceNoCase(arguments.missingMethodName, loc.key, "objects"), singularize(loc.key), "object"); // create a generic method name (example: "hasComments" becomes "hasObjects")
						if (loc.name == "objects")
						{
							loc.method = "findAll";
							arguments.missingMethodArguments.where = loc.where;
						}
						else if (loc.name == "addObject")
						{
							loc.method = "updateByKey";
							$setForeignKeyValues(missingMethodArguments=arguments.missingMethodArguments, keys=loc.info.foreignKey);
							$setObjectOrNumberToKey(arguments.missingMethodArguments);
						}
						else if (loc.name == "removeObject")
						{
							loc.method = "updateByKey";
							$setForeignKeyValues(missingMethodArguments=arguments.missingMethodArguments, keys=loc.info.foreignKey, setToNull=true);
							$setObjectOrNumberToKey(arguments.missingMethodArguments);
						}
						else if (loc.name == "deleteObject")
						{
							loc.method = "deleteByKey";
							$setObjectOrNumberToKey(arguments.missingMethodArguments);
						}
						else if (loc.name == "hasObjects")
						{
							loc.method = "exists";
							arguments.missingMethodArguments.where = loc.where;
						}
						else if (loc.name == "newObject")
						{
							loc.method = "new";
							$setForeignKeyValues(missingMethodArguments=arguments.missingMethodArguments, keys=loc.info.foreignKey);
						}
						else if (loc.name == "createObject")
						{
							loc.method = "create";
							$setForeignKeyValues(missingMethodArguments=arguments.missingMethodArguments, keys=loc.info.foreignKey);
						}
						else if (loc.name == "objectCount")
						{
							loc.method = "count";
							arguments.missingMethodArguments.where = loc.where;
						}
						else if (loc.name == "findOneObject")
						{
							loc.method = "findOne";
							arguments.missingMethodArguments.where = loc.where;
						}
						else if (loc.name == "removeAllObjects")
						{
							loc.method = "updateAll";
							arguments.missingMethodArguments.where = loc.where;
							$setForeignKeyValues(missingMethodArguments=arguments.missingMethodArguments, keys=loc.info.foreignKey, setToNull=true);
						}
						else if (loc.name == "deleteAllObjects")
						{
							loc.method = "deleteAll";
							arguments.missingMethodArguments.where = loc.where;
						}
					}
					else if (loc.info.type == "belongsTo")
					{
						loc.where = $keyWhereString(keys=loc.info.foreignKey, properties=variables.wheels.class.keys);
						if (StructKeyExists(arguments.missingMethodArguments, "where"))
							loc.where = "(#loc.where#) AND (#arguments.missingMethodArguments.where#)";
						loc.name = ReplaceNoCase(arguments.missingMethodName, loc.key, "object"); // create a generic method name (example: "hasAuthor" becomes "hasObject")
						if (loc.name == "object")
						{
							loc.method = "findByKey";
							arguments.missingMethodArguments.key = $propertyValue(name=loc.info.foreignKey);
						}
						else if (loc.name == "hasObject")
						{
							loc.method = "exists";
							arguments.missingMethodArguments.key = $propertyValue(name=loc.info.foreignKey);
						}
					}
					
				}
				if (Len(loc.method))
					loc.returnValue = $invoke(componentReference=model(loc.info.class), method=loc.method, argumentCollection=arguments.missingMethodArguments);
			}
		}
		if (!StructKeyExists(loc, "returnValue"))
			$throw(type="Wheels.MethodNotFound", message="The method `#arguments.missingMethodName#` was not found in this model.", extendedInfo="Check your spelling or add the method to the model's CFC file.");
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$propertyValue" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.returnValue = "";
		loc.iEnd = ListLen(arguments.name);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.returnValue = ListAppend(loc.returnValue, this[ListGetAt(arguments.name, loc.i)]);
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$setDefaultValues" returntype="any" access="public" output="false">
	<cfscript>
		var loc = {};
		loc.iEnd = ListLen(variables.wheels.class.propertyList);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.iItem = ListGetAt(variables.wheels.class.propertyList, loc.i);
			if (Len(variables.wheels.class.properties[loc.iItem].defaultValue) && (!StructKeyExists(this, loc.iItem) || !Len(this[loc.iItem])))
			{
				// set the default value unless it is blank or a value already exists for that property on the object
				this[loc.iItem] = variables.wheels.class.properties[loc.iItem].defaultValue;
			}
		}
	</cfscript>
</cffunction>

<cffunction name="$setForeignKeyValues" returntype="void" access="public" output="false">
	<cfargument name="missingMethodArguments" type="struct" required="true">
	<cfargument name="keys" type="string" required="true">
	<cfargument name="setToNull" type="boolean" required="false" default="false">
	<cfscript>
		var loc = {};
		loc.iEnd = ListLen(arguments.keys);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			if (arguments.setToNull)
				arguments.missingMethodArguments[ListGetAt(arguments.keys, loc.i)] = "";
			else
				arguments.missingMethodArguments[ListGetAt(arguments.keys, loc.i)] = this[ListGetAt(variables.wheels.class.keys, loc.i)];
		}
	</cfscript>
</cffunction>

<cffunction name="$setObjectOrNumberToKey" returntype="void" access="public" output="false">
	<cfargument name="missingMethodArguments" type="struct" required="true">
	<cfscript>
		var loc = {};
		loc.keyOrObject = arguments.missingMethodArguments[ListFirst(StructKeyList(arguments.missingMethodArguments))];
		StructDelete(arguments.missingMethodArguments, ListFirst(StructKeyList(arguments.missingMethodArguments)));
		if (IsObject(loc.keyOrObject))
			arguments.missingMethodArguments.key = loc.keyOrObject.key();
		else
			arguments.missingMethodArguments.key = loc.keyOrObject;
	</cfscript>
</cffunction>