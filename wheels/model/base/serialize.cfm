<cffunction name="$serializeStructsToObjects" access="public" output="false" returntype="any">
	<cfargument name="structs" type="any" required="true" />
	<cfargument name="include" type="string" required="true" />
	<cfargument name="callbacks" type="string" required="true" />
	<cfargument name="returnIncluded" type="string" required="true" />
	<cfscript>
		var loc = {};
		
		if (IsStruct(arguments.structs))
			loc.returnValue = [ arguments.structs ];
		else if (IsArray(arguments.structs))
			loc.returnValue = arguments.structs;
		
		loc.iEnd = ArrayLen(loc.returnValue);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
		
			if (Len(arguments.include) && arguments.returnIncluded)
			{
				// create each object from the assocations before creating our root object
				loc.xEnd = ListLen(arguments.include);
				for (loc.x = 1; loc.x lte loc.xEnd; loc.x++)
				{
					loc.include = ListGetAt(arguments.include, loc.x);
					loc.model = model(variables.wheels.class.associations[loc.include].modelName);
					if (variables.wheels.class.associations[loc.include].type == "hasMany")
					{
						loc.jEnd = ArrayLen(loc.returnValue[loc.i][loc.include]);
						for (loc.j=1; loc.j <= loc.jEnd; loc.j++)
							loc.returnValue[loc.i][loc.include][loc.j] = loc.model.$createInstance(properties=loc.returnValue[loc.i][loc.include][loc.j], persisted=true, base=false, callbacks=arguments.callbacks);
					}
					else
					{
						// we have a hasOne or belongsTo assocation, so just add the object to the root object
						loc.returnValue[loc.i][loc.include] = loc.model.$createInstance(properties=loc.returnValue[loc.i][loc.include], persisted=true, base=false, callbacks=arguments.callbacks);
					}
				}
			}
		
			// create an instance
			loc.returnValue[loc.i] = $createInstance(properties=loc.returnValue[loc.i], persisted=true, callbacks=arguments.callbacks);
		}
	</cfscript>
	<cfreturn loc.returnValue />
</cffunction>

<cffunction name="$keyFromStruct" access="public" output="false" returntype="string">
	<cfargument name="struct" type="struct" required="true">
	<cfscript>
		var loc = {};
		loc.returnValue = "";
		loc.iEnd = ListLen(primaryKeys());
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.property = primaryKeys(loc.i);
			if (StructKeyExists(arguments.struct, loc.property))
				loc.returnValue = ListAppend(loc.returnValue, arguments.struct[loc.property]);
		}
		</cfscript>
	<cfreturn loc.returnValue>
</cffunction>
