<cffunction name="table" returntype="void" access="public" output="false" hint="Use this method to tell Wheels what database table to connect to for this model. You only need to use this method when your table naming does not follow the standard Wheels conventions of a singular object name mapping to a plural table name (i.e. `User.cfc` mapping to the table `users` for example).">
	<cfargument name="name" type="string" required="true" hint="Name of the table to map this model to">
	<cfscript>
	variables.wheels.class.tableName = arguments.name;
	</cfscript>
</cffunction>

<cffunction name="property" returntype="void" access="public" output="false" hint="Use this method to map an object property in your application to a table column in your database. You only need to use this method when you want to override the mapping that Wheels performs (i.e. `user.firstName` mapping to `users.firstname` for example).">
	<cfargument name="name" type="string" required="true" hint="Name of the property">
	<cfargument name="column" type="string" required="true" hint="Name of the column to map the property to">
	<cfscript>
	variables.wheels.class.mapping[arguments.column] = arguments.name;
	</cfscript>
</cffunction>

<cffunction name="onMissingMethod" returntype="any" access="public" output="false">
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
			loc.finderProperties = ListToArray(ReplaceNoCase(ReplaceNoCase(Replace(arguments.missingMethodName, "And", "|"), "findAllBy", ""), "findOneBy", ""), "|");
			loc.firstProperty = loc.finderProperties[1];
			loc.secondProperty = IIf(ArrayLen(loc.finderProperties) == 2, "loc.finderProperties[2]", "");
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
				if (ListFindNoCase(variables.wheels.class.associations[loc.key].methods, arguments.missingMethodName))
				{
					// set name from "posts" to "objects", for example, so we can use it in the switch below --->
					loc.name = ReplaceNoCase(ReplaceNoCase(arguments.missingMethodName, pluralize(loc.key), "objects"), singularize(loc.key), "object");
					loc.info = $expandedAssociations(include=loc.key);
					loc.info = loc.info[1];
					loc.where = $keyWhereString(properties=loc.info.foreignKey, keys=variables.wheels.class.keys);
					if (StructKeyExists(arguments.missingMethodArguments, "where"))
						loc.where = "(#loc.where#) AND (#arguments.missingMethodArguments.where#)";
					if (loc.info.type == "hasOne")
					{
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
							arguments.missingMethodArguments.properties = $foreignKeyValues(keys=loc.info.foreignKey);
						}
						else if (loc.name == "createObject")
						{
							loc.method = "create";
							arguments.missingMethodArguments.properties = $foreignKeyValues(keys=loc.info.foreignKey);
						}
						else if (loc.name == "removeObject")
						{
							loc.method = "updateOne";
							arguments.missingMethodArguments.where = loc.where;
							arguments.missingMethodArguments.properties = $foreignKeyValues(keys=loc.info.foreignKey, setToNull=true);
						}
						else if (loc.name == "deleteObject")
						{
							loc.method = "deleteOne";
							arguments.missingMethodArguments.where = loc.where;
						}
						else if (loc.name == "setObject")
						{
							loc.method = "updateByKey";
							arguments.missingMethodArguments.properties = $foreignKeyValues(keys=loc.info.foreignKey);
							arguments.missingMethodArguments = $objectOrNumberToKey(arguments.missingMethodArguments);
						}
					}
					else if (loc.info.type == "hasMany")
					{
						if (loc.name == "objects")
						{
							loc.method = "findAll";
							arguments.missingMethodArguments.where = loc.where;
						}
						else if (loc.name == "addObject")
						{
							loc.method = "updateByKey";
							arguments.missingMethodArguments.properties = $foreignKeyValues(keys=loc.info.foreignKey);
							arguments.missingMethodArguments = $objectOrNumberToKey(arguments.missingMethodArguments);
						}
						else if (loc.name == "removeObject")
						{
							loc.method = "updateByKey";
							arguments.missingMethodArguments.properties = $foreignKeyValues(keys=loc.info.foreignKey, setToNull=true);
							arguments.missingMethodArguments = $objectOrNumberToKey(arguments.missingMethodArguments);
						}
						else if (loc.name == "deleteObject")
						{
							loc.method = "deleteByKey";
							arguments.missingMethodArguments = $objectOrNumberToKey(arguments.missingMethodArguments);
						}
						else if (loc.name == "hasObjects")
						{
							loc.method = "exists";
							arguments.missingMethodArguments.where = loc.where;
						}
						else if (loc.name == "newObject")
						{
							loc.method = "new";
							arguments.missingMethodArguments.properties = $foreignKeyValues(keys=loc.info.foreignKey);
						}
						else if (loc.name == "createObject")
						{
							loc.method = "create";
							arguments.missingMethodArguments.properties = $foreignKeyValues(keys=loc.info.foreignKey);
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
							arguments.missingMethodArguments.properties = $foreignKeyValues(keys=loc.info.foreignKey, setToNull=true);
						}
						else if (loc.name == "deleteAllObjects")
						{
							loc.method = "deleteAll";
							arguments.missingMethodArguments.where = loc.where;
						}
					}
					else if (loc.info.type == "belongsTo")
					{
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
					loc.returnValue = $invoke(component=model(loc.info.class), method=loc.method, argumentCollection=arguments.missingMethodArguments);					
				}
			}
		}
		if (!StructKeyExists(loc, "returnValue"))
			$throw(type="Wheels.MethodNotFound", message="The method #arguments.missingMethodName# was not found in this model.", extendedInfo="Check your spelling or add the method to the model CFC file.");
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="columnNames" returntype="string" access="public" output="false" hint="Returns a list of column names (ordered by their position in the database table).">
	<cfreturn variables.wheels.class.columnList>
</cffunction>

<cffunction name="propertyNames" returntype="string" access="public" output="false" hint="Returns a list of property names (ordered by their respective column's position in the database table).">
	<cfreturn variables.wheels.class.propertyList>
</cffunction>

<cffunction name="$objectOrNumberToKey" returntype="struct" access="public" output="false">
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
	<cfreturn arguments.missingMethodArguments>
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

<cffunction name="$foreignKeyValues" returntype="struct" access="public" output="false">
	<cfargument name="keys" type="string" required="true">
	<cfargument name="setToNull" type="boolean" required="false" default="false">
	<cfscript>
		var loc = {};
		loc.returnValue = {};
		loc.iEnd = ListLen(arguments.keys);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			if (arguments.setToNull)
				loc.returnValue[ListGetAt(arguments.keys, loc.i)] = "";
			else
				loc.returnValue[ListGetAt(arguments.keys, loc.i)] = this[ListGetAt(variables.wheels.class.keys, loc.i)];	
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="connection" returntype="void" access="public" output="false" hint="Use this method to override the datasource connection information for a particular model">
	<cfargument name="datasource" required="true" type="string" hint="the datasource to connect to">
	<cfargument name="username" required="true" type="string" hint="the username for the connection">
	<cfargument name="password" required="true" type="string" hint="the password for the connection">
	<cfscript>
	structappend(variables.wheels.class.connection, arguments, true);
	</cfscript>
</cffunction>