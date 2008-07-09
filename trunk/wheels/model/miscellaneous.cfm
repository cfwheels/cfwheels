<cffunction name="$classData" returntype="struct" access="public" output="false">
	<cfreturn variables.wheels.class>
</cffunction>

<cffunction name="onMissingMethod" returntype="any" access="public" output="false">
	<cfargument name="missingMethodName" type="string" required="true">
	<cfargument name="missingMethodArguments" type="struct" required="true">
	<cfscript>
		var loc = {};
		if (Right(arguments.missingMethodName, 10) == "hasChanged")
			loc.returnValue = hasChanged(property=replaceNoCase(arguments.missingMethodName, "hasChanged", ""));
		else if (Right(arguments.missingMethodName, 11) == "changedFrom")
			loc.returnValue = $changedFrom(property=replaceNoCase(arguments.missingMethodName, "changedFrom", ""));
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
					loc.name = ReplaceNoCase(ReplaceNoCase(arguments.missingMethodName, $pluralize(loc.key), "objects"), $singularize(loc.key), "object");
					if (loc.name == "setObject" || loc.name == "addObject" || loc.name == "deleteObject")
					{
						loc.object = arguments.missingMethodArguments[ListFirst(StructKeyList(arguments.missingMethodArguments))];
						if (!IsObject(loc.object))
							loc.object = findById(loc.object);
					}
					$dump(loc.object);
					loc.info = $expandedAssociations(include=loc.key);
					loc.info = loc.info[1];
					if (loc.info.type == "hasOne" || loc.info.type == "hasMany")
					{
						loc.simpleWhere = $keyWhereString(properties=loc.info.foreignKey, keys=variables.wheels.class.keys);
						loc.fullWhere = loc.simpleWhere;
						if (StructKeyExists(arguments.missingMethodArguments, "where"))
							loc.fullWhere = "(#loc.fullWhere#) AND (#arguments.missingMethodArguments.where#)";
						switch(loc.name)
						{
							case "object":
							{
								loc.returnValue = model(loc.info.class).findOne(where=loc.simpleWhere);
								break;
							}
							case "objects":
							{
								loc.returnValue = model(loc.info.class).findAll(where=loc.simpleWhere);
								break;
							}
							case "setObject":
							case "addObject":
							{
								loc.iEnd = ListLen(loc.info.foreignKey);
								for (loc.i=1; loc.i<=loc.iEnd; loc.i++)
								{
									loc.properties[ListGetAt(loc.info.foreignKey, loc.i)] = this[ListGetAt(variables.wheels.class.keys, loc.i)];
								}
								loc.returnValue = loc.object.update(properties=loc.properties);
								break;
							}
							case "deleteObject":
							{
								loc.iEnd = ListLen(loc.info.foreignKey);
								for (loc.i=1; loc.i<=loc.iEnd; loc.i++)
								{
									loc.properties[ListGetAt(loc.info.foreignKey, loc.i)] = "";
								}
								loc.returnValue = loc.object.update(properties=loc.properties);
								break;
							}
							case "clearObjects":
							{
								arguments.missingMethodArguments.where = loc.fullWhere;
								loc.iEnd = ListLen(loc.info.foreignKey);
								for (loc.i=1; loc.i<=loc.iEnd; loc.i++)
								{
									arguments.missingMethodArguments.properties[ListGetAt(loc.info.foreignKey, loc.i)] = "";
								}
								loc.returnValue = model(loc.info.class).updateAll(argumentCollection=arguments.missingMethodArguments);
								break;
							}
							case "newObject":
							{
								loc.iEnd = ListLen(loc.info.foreignKey);
								for (loc.i=1; loc.i<=loc.iEnd; loc.i++)
								{
									arguments.missingMethodArguments[ListGetAt(loc.info.foreignKey, loc.i)] = this[ListGetAt(variables.wheels.class.keys, loc.i)];
								}
								loc.returnValue = model(loc.info.class).new(argumentCollection=arguments.missingMethodArguments);
								break;
							}
							case "createObject":
							{
								loc.iEnd = ListLen(loc.info.foreignKey);
								for (loc.i=1; loc.i<=loc.iEnd; loc.i++)
								{
									arguments.missingMethodArguments[ListGetAt(loc.info.foreignKey, loc.i)] = this[ListGetAt(variables.wheels.class.keys, loc.i)];
								}
								loc.returnValue = model(loc.info.class).create(argumentCollection=arguments.missingMethodArguments);
								break;
							}
							case "findOneObject":
							{
								arguments.missingMethodArguments.where = loc.fullWhere;
								loc.returnValue = model(loc.info.class).findOne(argumentCollection=arguments.missingMethodArguments);
								break;
							}
							case "findAllObjects":
							{
								arguments.missingMethodArguments.where = loc.fullWhere;
								loc.returnValue = model(loc.info.class).findAll(argumentCollection=arguments.missingMethodArguments);
								break;
							}
							case "hasObject":
							case "hasObjects":
							{
								loc.returnValue = model(loc.info.class).count(where=loc.simpleWhere) != 0;
								break;
							}
							case "objectCount":
							{
								loc.returnValue = model(loc.info.class).count(where=loc.simpleWhere);
								break;
							}
						}
					}
					else if (loc.info.type == "belongsTo")
					{
						switch(loc.name)
						{
							case "object":
							{
								loc.returnValue = model(loc.info.class).findById(this[loc.info.foreignKey]);
								break;
							}
							case "setObject":
							{
								loc.iEnd = ListLen(loc.info.foreignKey);
								for (loc.i=1; loc.i<=loc.iEnd; loc.i++)
								{
									this[ListGetAt(loc.info.foreignKey, loc.i)] = loc.object[ListGetAt(loc.object.$classData().keys, loc.i)];
								}
								loc.returnValue = save();
								break;
							}
							case "hasObject":
							{
								loc.id = "";
								loc.iEnd = ListLen(loc.info.foreignKey);
								for (loc.i=1; loc.i<=loc.iEnd; loc.i++)
								{
									loc.id = ListAppend(loc.id, this[ListGetAt(loc.info.foreignKey, loc.i)]);
								}
								loc.returnValue = IsObject(model(loc.info.class).findById(loc.id));
								break;
							}
						}
					}
				}
			}
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>