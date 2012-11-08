<cffunction name="onMissingMethod" returntype="any" access="public" output="false" hint="This method handles dynamic finders, properties, and association methods. It is not part of the public API.">
	<cfargument name="missingMethodName" type="string" required="true" hint="Name of method attempted to load.">
	<cfargument name="missingMethodArguments" type="struct" required="true" hint="Name/value pairs of arguments that were passed to the attempted method call.">
	<cfscript>
		var loc = {};
		if (Right(arguments.missingMethodName, 10) == "hasChanged" && StructKeyExists(variables.wheels.class.properties,ReplaceNoCase(arguments.missingMethodName, "hasChanged", "")))
		{
			loc.returnValue = hasChanged(property=ReplaceNoCase(arguments.missingMethodName, "hasChanged", ""));
		}
		else if (Right(arguments.missingMethodName, 11) == "changedFrom" && StructKeyExists(variables.wheels.class.properties, ReplaceNoCase(arguments.missingMethodName, "changedFrom", "")))
		{
			loc.returnValue = changedFrom(property=ReplaceNoCase(arguments.missingMethodName, "changedFrom", ""));
		}
		else if (Right(arguments.missingMethodName, 9) == "IsPresent" && StructKeyExists(variables.wheels.class.properties, ReplaceNoCase(arguments.missingMethodName, "IsPresent", "")))
		{
			loc.returnValue = propertyIsPresent(property=ReplaceNoCase(arguments.missingMethodName, "IsPresent", ""));
		}
		else if (Left(arguments.missingMethodName, 3) == "has" && StructKeyExists(variables.wheels.class.properties, ReplaceNoCase(arguments.missingMethodName, "has", "")))
		{
			loc.returnValue = hasProperty(property=ReplaceNoCase(arguments.missingMethodName, "has", ""));
		}
		
		if (!StructKeyExists(loc, "returnValue"))
		{
			$raiseMethodNotFound(argumentCollection=arguments);
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="$raiseMethodNotFound" returntype="void" access="public" output="false">
	<cfargument name="missingMethodName" type="string" required="true" hint="Name of method attempted to load.">
	<cfargument name="missingMethodArguments" type="struct" required="true" hint="Name/value pairs of arguments that were passed to the attempted method call.">
	<cfset $throw(type="Wheels.MethodNotFound", message="The method `#arguments.missingMethodName#` was not found in the `#variables.wheels.class.modelName#` model.", extendedInfo="Check your spelling or add the method to the model's CFC file.")>
</cffunction>

<cffunction name="$propertyValue" returntype="string" access="public" output="false" hint="Returns the object's value of the passed in property name. If you pass in a list of property names you will get the values back in a list as well.">
	<cfargument name="name" type="string" required="true" hint="Name of property to get value for.">
	<cfscript>
		var loc = {};
		loc.returnValue = "";
		loc.iEnd = ListLen(arguments.name);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			loc.returnValue = ListAppend(loc.returnValue, this[ListGetAt(arguments.name, loc.i)]);
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>