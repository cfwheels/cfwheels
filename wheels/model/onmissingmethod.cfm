<!--- PUBLIC DYNAMIC MODEL METHODS --->

<cffunction name="onMissingMethod" returntype="any" access="public" output="false">
	<cfargument name="missingMethodName" type="string" required="true">
	<cfargument name="missingMethodArguments" type="struct" required="true">
	<cfscript>
		var loc = {};
		if (Right(arguments.missingMethodName, 10) == "hasChanged" && StructKeyExists(variables.wheels.class.properties, ReplaceNoCase(arguments.missingMethodName, "hasChanged", "")))
		{
			loc.rv = hasChanged(property=ReplaceNoCase(arguments.missingMethodName, "hasChanged", ""));
		}
		else if (Right(arguments.missingMethodName, 11) == "changedFrom" && StructKeyExists(variables.wheels.class.properties, ReplaceNoCase(arguments.missingMethodName, "changedFrom", "")))
		{
			loc.rv = changedFrom(property=ReplaceNoCase(arguments.missingMethodName, "changedFrom", ""));
		}
		else if (Right(arguments.missingMethodName, 9) == "IsPresent" && StructKeyExists(variables.wheels.class.properties, ReplaceNoCase(arguments.missingMethodName, "IsPresent", "")))
		{
			loc.rv = propertyIsPresent(property=ReplaceNoCase(arguments.missingMethodName, "IsPresent", ""));
		}
		else if (Left(arguments.missingMethodName, 9) == "columnFor" && StructKeyExists(variables.wheels.class.properties, ReplaceNoCase(arguments.missingMethodName, "columnFor", "")))
		{
			loc.rv = columnForProperty(property=ReplaceNoCase(arguments.missingMethodName, "columnFor", ""));
		}
		else if (Left(arguments.missingMethodName, 6) == "toggle" && StructKeyExists(variables.wheels.class.properties, ReplaceNoCase(arguments.missingMethodName, "toggle", "")))
		{
			loc.rv = toggle(property=ReplaceNoCase(arguments.missingMethodName, "toggle", ""), argumentCollection=arguments.missingMethodArguments);
		}
		else if (Left(arguments.missingMethodName, 3) == "has" && StructKeyExists(variables.wheels.class.properties, ReplaceNoCase(arguments.missingMethodName, "has", "")))
		{
			loc.rv = hasProperty(property=ReplaceNoCase(arguments.missingMethodName, "has", ""));
		}
		else if (Left(arguments.missingMethodName, 6) == "update" && StructKeyExists(variables.wheels.class.properties, ReplaceNoCase(arguments.missingMethodName, "update", "")))
		{
			if (!StructKeyExists(arguments.missingMethodArguments, "value"))
			{
				$throw(type="Wheels.IncorrectArguments", message="The `value` argument is required but was not passed in.", extendedInfo="Pass in a value to the dynamic updateProperty in the `value` argument.");
			}
			loc.rv = updateProperty(property=ReplaceNoCase(arguments.missingMethodName, "update", ""), value=arguments.missingMethodArguments.value);
		}
		else if (Left(arguments.missingMethodName, 9) == "findOneBy" || Left(arguments.missingMethodName, 9) == "findAllBy")
		{
			if (StructKeyExists(server, "railo") || StructKeyExists(server, "lucee"))
			{
				// since Railo passes in the method name in all upper case we have to do this here
				loc.finderProperties = ListToArray(LCase(ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(arguments.missingMethodName, "And", "|", "all"), "findAllBy", "", "all"), "findOneBy", "", "all")), "|");
			}
			else
			{
				loc.finderProperties = ListToArray(ReplaceNoCase(ReplaceNoCase(Replace(arguments.missingMethodName, "And", "|", "all"), "findAllBy", "", "all"), "findOneBy", "", "all"), "|");
			}

			// sometimes values will have commas in them, allow the developer to change the delimiter
			loc.delimiter = ",";
			if (StructKeyExists(arguments.missingMethodArguments, "delimiter"))
			{
				loc.delimiter = arguments.missingMethodArguments["delimiter"];
			}

			// split the values into an array for easier processing
			loc.values = "";
			if (StructKeyExists(arguments.missingMethodArguments, "value"))
			{
				loc.values = arguments.missingMethodArguments.value;
			}
			else if (StructKeyExists(arguments.missingMethodArguments, "values"))
			{
				loc.values = arguments.missingMethodArguments.values;
			}
			else
			{
				loc.values = arguments.missingMethodArguments[1];
			}

			if (!IsArray(loc.values))
			{
				if (ArrayLen(loc.finderProperties) == 1)
				{
					// don't know why but this screws up in CF8
					loc.temp = [];
					ArrayAppend(loc.temp, loc.values);
					loc.values = loc.temp;
				}
				else
				{
					loc.values = $listClean(list=loc.values, delim=loc.delimiter, returnAs="array");
				}
			}

			// where clause
			loc.addToWhere = [];

			// loop through all the properties they want to query and assign values
			loc.iEnd = ArrayLen(loc.finderProperties);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				ArrayAppend(loc.addToWhere, "#loc.finderProperties[loc.i]# #$dynamicFinderOperator(loc.finderProperties[loc.i])# #variables.wheels.class.adapter.$quoteValue(str=loc.values[loc.i], type=validationTypeForProperty(loc.finderProperties[loc.i]))#");
			}

			// construct where clause
			loc.addToWhere = ArrayToList(loc.addToWhere, " AND ");
			arguments.missingMethodArguments.where = IIf(StructKeyExists(arguments.missingMethodArguments, "where") && Len(arguments.missingMethodArguments.where), "'(' & arguments.missingMethodArguments.where & ') AND (' & loc.addToWhere & ')'", "loc.addToWhere");

			// remove uneeded arguments
			StructDelete(arguments.missingMethodArguments, "delimiter");
			StructDelete(arguments.missingMethodArguments, "1");
			StructDelete(arguments.missingMethodArguments, "value");
			StructDelete(arguments.missingMethodArguments, "values");

			// call finder method
			loc.rv = IIf(Left(arguments.missingMethodName, 9) == "findOneBy", "findOne(argumentCollection=arguments.missingMethodArguments)", "findAll(argumentCollection=arguments.missingMethodArguments)");
		}
		else if (Left(arguments.missingMethodName, 14) == "findOrCreateBy")
		{
			loc.rv = $findOrCreateBy(argumentCollection=arguments);
		}
		else
		{
			loc.rv = $associationMethod(argumentCollection=arguments);
		}
		if (!StructKeyExists(loc, "rv"))
		{
			$throw(type="Wheels.MethodNotFound", message="The method `#arguments.missingMethodName#` was not found in the `#variables.wheels.class.modelName#` model.", extendedInfo="Check your spelling or add the method to the model's CFC file.");
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PRIVATE METHODS --->

<cffunction name="$findOrCreateBy" returntype="any" access="public" output="false">
	<cfscript>
		var loc = {};

		// default save to true but set to passed in value if it exists and then delete from arguments
		loc.save = true;
		if (StructKeyExists(arguments.missingMethodArguments, "save"))
		{
			loc.save = arguments.missingMethodArguments.save;
			StructDelete(arguments.missingMethodArguments, "save");
		}

		// get the property name from the last part of the function name
		loc.property = ReplaceNoCase(arguments.missingMethodName, "findOrCreateBy", "");

		// get the value from the parameter that matches the property name or the first one if named arguments were not used
		if (StructKeyExists(arguments.missingMethodArguments, "1"))
		{
			arguments.missingMethodArguments[loc.property] = arguments.missingMethodArguments[1];
			StructDelete(arguments.missingMethodArguments, "1");
		}
		loc.value = arguments.missingMethodArguments[loc.property];

		loc.object = findOne(where=$keyWhereString(loc.property, loc.value));
		if (IsObject(loc.object))
		{
			loc.rv = loc.object;
		}
		else
		{
			StructDelete(arguments, "missingMethodName");
			StructDelete(arguments.missingMethodArguments, loc.property);
			StructAppend(arguments, arguments.missingMethodArguments);
			StructDelete(arguments, "missingMethodArguments");
			arguments[loc.property] = loc.value;
			if (loc.save)
			{
				loc.rv = create(argumentCollection=arguments);
			}
			else
			{
				loc.rv = new(argumentCollection=arguments);
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$dynamicFinderOperator" returntype="string" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfscript>
		var loc = {};
		if (StructKeyExists(variables.wheels.class.properties, arguments.property) && variables.wheels.class.properties[arguments.property].dataType == "text")
		{
			loc.rv = "LIKE";
		}
		else
		{
			loc.rv =  "=";
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="$associationMethod" returntype="any" access="public" output="false">
	<cfscript>
		var loc = {};
		for (loc.key in variables.wheels.class.associations)
		{
			loc.method = "";
			if (StructKeyExists(variables.wheels.class.associations[loc.key], "shortcut") && arguments.missingMethodName == variables.wheels.class.associations[loc.key].shortcut)
			{
				loc.method = "findAll";
				loc.joinAssociation = $expandedAssociations(include=loc.key);
				loc.joinAssociation = loc.joinAssociation[1];
				loc.joinClass = loc.joinAssociation.modelName;
				loc.info = model(loc.joinClass).$expandedAssociations(include=ListFirst(variables.wheels.class.associations[loc.key].through));
				loc.info = loc.info[1];
				loc.componentReference = model(loc.info.modelName);
				loc.include = ListLast(variables.wheels.class.associations[loc.key].through);
				if (StructKeyExists(arguments.missingMethodArguments, "include"))
				{
					loc.include = "#loc.include#(#arguments.missingMethodArguments.include#)";
				}
				arguments.missingMethodArguments.include = loc.include;
				loc.where = $keyWhereString(properties=loc.joinAssociation.foreignKey, keys=loc.componentReference.primaryKeys());
				if (StructKeyExists(arguments.missingMethodArguments, "where"))
				{
					loc.where = "(#loc.where#) AND (#arguments.missingMethodArguments.where#)";
				}
				arguments.missingMethodArguments.where = loc.where;
				if (!StructKeyExists(arguments.missingMethodArguments, "returnIncluded"))
				{
					arguments.missingMethodArguments.returnIncluded = false;
				}
			}
			else if (ListFindNoCase(variables.wheels.class.associations[loc.key].methods, arguments.missingMethodName))
			{
				loc.info = $expandedAssociations(include=loc.key);
				loc.info = loc.info[1];
				loc.componentReference = model(loc.info.modelName);
				if (loc.info.type == "hasOne")
				{
					loc.where = $keyWhereString(properties=loc.info.foreignKey, keys=primaryKeys());
					if (StructKeyExists(arguments.missingMethodArguments, "where") && Len(arguments.missingMethodArguments.where))
					{
						loc.where = "(#loc.where#) AND (#arguments.missingMethodArguments.where#)";
					}

					// create a generic method name (example: "hasProfile" becomes "hasObject")
					loc.name = ReplaceNoCase(arguments.missingMethodName, loc.key, "object");

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
						// single argument, must be either the key or the object
						if (StructCount(arguments.missingMethodArguments) == 1)
						{
							if (IsObject(arguments.missingMethodArguments[1]))
							{
								loc.componentReference = arguments.missingMethodArguments[1];
								loc.method = "update";
							}
							else
							{
								arguments.missingMethodArguments.key = arguments.missingMethodArguments[1];
								loc.method = "updateByKey";
							}
							StructClear(arguments.missingMethodArguments);
						}
						else
						{
							// multiple arguments so ensure that either 'key' or the association name exists (loc.key)
							if (StructKeyExists(arguments.missingMethodArguments, loc.key) && IsObject(arguments.missingMethodArguments[loc.key]))
							{
								loc.componentReference = arguments.missingMethodArguments[loc.key];
								loc.method = "update";
								StructDelete(arguments.missingMethodArguments, loc.key);
							}
							else if (StructKeyExists(arguments.missingMethodArguments, "key"))
							{
								loc.method = "updateByKey";
							}
							else
							{
								$throw(type="Wheels.IncorrectArguments", message="The `#loc.key#` or `key` named argument is required.", extendedInfo="When using multiple arguments for #loc.name#() you must supply an object using the argument `#loc.key#` or a key using the argument `key`, e.g. #loc.name#(#loc.key#=post) or #loc.name#(key=post.id).");
							}
						}
						$setForeignKeyValues(missingMethodArguments=arguments.missingMethodArguments, keys=loc.info.foreignKey);
					}
				}
				else if (loc.info.type == "hasMany")
				{
					loc.where = $keyWhereString(properties=loc.info.foreignKey, keys=primaryKeys());
					if (StructKeyExists(arguments.missingMethodArguments, "where") && Len(arguments.missingMethodArguments.where))
					{
						loc.where = "(#loc.where#) AND (#arguments.missingMethodArguments.where#)";
					}
					loc.singularKey = singularize(loc.key);

					// create a generic method name (example: "hasComments" becomes "hasObjects")
					loc.name = ReplaceNoCase(arguments.missingMethodName, loc.key, "objects");
					if (loc.name == arguments.missingMethodName)
					{
						// we should never change anything more than once so if the plural version was already replaced we do not need to replace the singular one
						loc.name = ReplaceNoCase(loc.name, loc.singularKey, "object");
					}

					if (loc.name == "objects")
					{
						loc.method = "findAll";
						arguments.missingMethodArguments.where = loc.where;
					}
					else if (loc.name == "addObject")
					{
						// single argument, must be either the key or the object
						if (StructCount(arguments.missingMethodArguments) == 1)
						{
							if (IsObject(arguments.missingMethodArguments[1]))
							{
								loc.componentReference = arguments.missingMethodArguments[1];
								loc.method = "update";
							}
							else
							{
								arguments.missingMethodArguments.key = arguments.missingMethodArguments[1];
								loc.method = "updateByKey";
							}
							StructClear(arguments.missingMethodArguments);
						}
						else
						{
							// multiple arguments so ensure that either 'key' or the singularized association name exists (loc.singularKey)
							if (StructKeyExists(arguments.missingMethodArguments, loc.singularKey) && IsObject(arguments.missingMethodArguments[loc.singularKey]))
							{
								loc.componentReference = arguments.missingMethodArguments[loc.singularKey];
								loc.method = "update";
								StructDelete(arguments.missingMethodArguments, loc.singularKey);
							}
							else if (StructKeyExists(arguments.missingMethodArguments, "key"))
							{
								loc.method = "updateByKey";
							}
							else
							{
								$throw(type="Wheels.IncorrectArguments", message="The `#loc.singularKey#` or `key` named argument is required.", extendedInfo="When using multiple arguments for #loc.name#() you must supply an object using the argument `#loc.singularKey#` or a key using the argument `key`, e.g. #loc.name#(#loc.singularKey#=post) or #loc.name#(key=post.id).");
							}
						}
						$setForeignKeyValues(missingMethodArguments=arguments.missingMethodArguments, keys=loc.info.foreignKey);
					}
					else if (loc.name == "removeObject")
					{
						// single argument, must be either the key or the object
						if (StructCount(arguments.missingMethodArguments) == 1)
						{
							if (IsObject(arguments.missingMethodArguments[1]))
							{
								loc.componentReference = arguments.missingMethodArguments[1];
								loc.method = "update";
							}
							else
							{
								arguments.missingMethodArguments.key = arguments.missingMethodArguments[1];
								loc.method = "updateByKey";
							}
							StructClear(arguments.missingMethodArguments);
						}
						else
						{
							// multiple arguments so ensure that either 'key' or the singularized object name exists (loc.singularKey)
							if (StructKeyExists(arguments.missingMethodArguments, loc.singularKey) && IsObject(arguments.missingMethodArguments[loc.singularKey]))
							{
								loc.componentReference = arguments.missingMethodArguments[loc.singularKey];
								loc.method = "update";
								StructDelete(arguments.missingMethodArguments, loc.singularKey);
							}
							else if (StructKeyExists(arguments.missingMethodArguments, "key"))
							{
								loc.method = "updateByKey";
							}
							else
							{
								$throw(type="Wheels.IncorrectArguments", message="The `#loc.singularKey#` or `key` named argument is required.", extendedInfo="When using multiple arguments for #loc.name#() you must supply an object using the argument `#loc.singularKey#` or a key using the argument `key`, e.g. #loc.name#(#loc.singularKey#=post) or #loc.name#(key=post.id).");
							}
						}
						$setForeignKeyValues(missingMethodArguments=arguments.missingMethodArguments, keys=loc.info.foreignKey, setToNull=true);
					}
					else if (loc.name == "deleteObject")
					{
						// single argument, must be either the key or the object
						if (StructCount(arguments.missingMethodArguments) == 1)
						{
							if (IsObject(arguments.missingMethodArguments[1]))
							{
								loc.componentReference = arguments.missingMethodArguments[1];
								loc.method = "delete";
							}
							else
							{
								arguments.missingMethodArguments.key = arguments.missingMethodArguments[1];
								loc.method = "deleteByKey";
							}
							StructClear(arguments.missingMethodArguments);
						}
						else
						{
							// multiple arguments so ensure that either 'key' or the singularized object name exists (loc.singularKey)
							if (StructKeyExists(arguments.missingMethodArguments, loc.singularKey) && IsObject(arguments.missingMethodArguments[loc.singularKey]))
							{
								loc.componentReference = arguments.missingMethodArguments[loc.singularKey];
								loc.method = "delete";
								StructDelete(arguments.missingMethodArguments, loc.singularKey);
							}
							else if (StructKeyExists(arguments.missingMethodArguments, "key"))
							{
								loc.method = "deleteByKey";
							}
							else
							{
								$throw(type="Wheels.IncorrectArguments", message="The `#loc.singularKey#` or `key` named argument is required.", extendedInfo="When using multiple arguments for #loc.name#() you must supply an object using the argument `#loc.singularKey#` or a key using the argument `key`, e.g. #loc.name#(#loc.singularKey#=post) or #loc.name#(key=post.id).");
							}
						}
						$setForeignKeyValues(missingMethodArguments=arguments.missingMethodArguments, keys=loc.info.foreignKey);
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
					loc.where = $keyWhereString(keys=loc.info.foreignKey, properties=loc.componentReference.primaryKeys());
					if (StructKeyExists(arguments.missingMethodArguments, "where") && Len(arguments.missingMethodArguments.where))
					{
						loc.where = "(#loc.where#) AND (#arguments.missingMethodArguments.where#)";
					}

					// create a generic method name (example: "hasAuthor" becomes "hasObject")
					loc.name = ReplaceNoCase(arguments.missingMethodName, loc.key, "object");

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
			{
				loc.rv = $invoke(componentReference=loc.componentReference, method=loc.method, invokeArgs=arguments.missingMethodArguments);
			}
		}
	</cfscript>
	<cfif StructKeyExists(loc, "rv")>
		<cfreturn loc.rv>
	</cfif>
</cffunction>

<cffunction name="$propertyValue" returntype="string" access="public" output="false">
	<cfargument name="name" type="string" required="true">
	<cfscript>
		var loc = {};
		loc.rv = "";
		loc.iEnd = ListLen(arguments.name);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = ListGetAt(arguments.name, loc.i);
			loc.rv = ListAppend(loc.rv, this[loc.item]);
		}
	</cfscript>
	<cfreturn loc.rv>
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
			loc.item = ListGetAt(arguments.keys, loc.i);
			if (arguments.setToNull)
			{
				arguments.missingMethodArguments[loc.item] = "";
			}
			else
			{
				arguments.missingMethodArguments[loc.item] = this[primaryKeys(loc.i)];
			}
		}
	</cfscript>
</cffunction>