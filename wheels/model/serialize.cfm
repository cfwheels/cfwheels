<cffunction name="$serializeQueryToObjects" access="public" output="false" returntype="any">
	<cfargument name="query" type="query" required="true" />
	<cfargument name="include" type="string" required="true" />
	<cfargument name="callbacks" type="string" required="true" />
	<cfargument name="returnIncluded" type="string" required="true" />
	<cfscript>
		var loc = {};
		loc.returnValue = [];
		loc.doneObjects = "";
		for (loc.i=1; loc.i <= arguments.query.recordCount; loc.i++)
		{
			loc.object = $createInstance(properties=arguments.query, persisted=true, row=loc.i, callbacks=arguments.callbacks);
			if (!ListFind(loc.doneObjects, loc.object.key(), Chr(7)))
			{
				if (Len(arguments.include) && arguments.returnIncluded)
				{
					loc.xEnd = ListLen(arguments.include);
					for (loc.x = 1; loc.x lte loc.xEnd; loc.x++)
					{
						loc.include = ListGetAt(arguments.include, loc.x);
						if (variables.wheels.class.associations[loc.include].type == "hasMany")
						{
							loc.object[loc.include] = [];
							loc.hasManyDoneObjects = "";
							for (loc.j=1; loc.j <= arguments.query.recordCount; loc.j++)
							{
								// is there anything we can do here to not instantiate an object if it is not going to be use or is already created
								loc.hasManyObject = model(variables.wheels.class.associations[loc.include].modelName).$createInstance(properties=arguments.query, persisted=true, row=loc.j, base=false, callbacks=arguments.callbacks);
								if (!ListFind(loc.hasManyDoneObjects, loc.hasManyObject.key(), Chr(7)))
								{
									// create object instance from values in current query row if it belongs to the current object
									loc.primaryKeyColumnValues = "";
									loc.kEnd = ListLen(variables.wheels.class.keys);
									for (loc.k=1; loc.k <= loc.kEnd; loc.k++)
									{
										loc.primaryKeyColumnValues = ListAppend(loc.primaryKeyColumnValues, arguments.query[ListGetAt(variables.wheels.class.keys, loc.k)][loc.j]);
									}
									if (Len(loc.hasManyObject.key()) && loc.object.key() == loc.primaryKeyColumnValues)
										ArrayAppend(loc.object[loc.include], loc.hasManyObject);

									loc.hasManyDoneObjects = ListAppend(loc.hasManyDoneObjects, loc.hasManyObject.key(), Chr(7));
								}
							}
						}
						else
						{
							loc.object[loc.include] = model(variables.wheels.class.associations[loc.include].modelName).$createInstance(properties=arguments.query, persisted=true, row=loc.i, base=false, callbacks=arguments.callbacks);
						}
					}
				}
				ArrayAppend(loc.returnValue, loc.object);
				loc.doneObjects = ListAppend(loc.doneObjects, loc.object.key(), Chr(7));
			}
		}	
	</cfscript>
	<cfreturn loc.returnValue />
</cffunction>