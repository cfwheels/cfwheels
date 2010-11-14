<cffunction name="distinct" returntype="component" output="false" access="public">
	<cfargument name="value" type="boolean" required="false" default="true" />
	<cfscript>
		variables.wheels.query.distinct = arguments.value;
	</cfscript>
	<cfreturn this />
</cffunction>

<cffunction name="select" returntype="component" output="false" access="public">
	<cfargument name="properties" type="string" required="true" />
	<cfset variables.wheels.query.select = ListAppend(variables.wheels.query.select, $listClean(arguments.properties)) />
	<cfreturn this />
</cffunction>

<cffunction name="include" returntype="component" output="false" access="public">
	<cfargument name="associations" type="string" required="false" default="" />
	<cfscript>
		arguments.associations = $listClean(arguments.associations);
		// we could also have an association argument
		if (!Len(arguments.associations) && StructKeyExists(arguments, "association"))
			arguments.associations = $listClean(arguments.association);
			
		variables.wheels.query.include = ListAppend(variables.wheels.query.include, arguments.associations);
	</cfscript>
	<cfreturn this />
</cffunction>

<cffunction name="order" returntype="component" output="false" access="public">
	<cfargument name="property" type="string" required="true" />
	<cfargument name="direction" type="string" required="false" default="ASC" />
	<cfscript>
		var loc = {};
		ArrayAppend(variables.wheels.query.order, StructNew());
		loc.length = ArrayLen(ariables.wheels.query.order);
		variables.wheels.query.order[loc.length][arguments.property] = arguments.property;
		variables.wheels.query.order[loc.length].direction = UCase(arguments.direction);
	</cfscript>
	<cfreturn this />
</cffunction>

<cffunction name="group" returntype="component" output="false" access="public">
	<cfargument name="properties" type="string" required="true" />
	<cfset variables.wheels.query.group = ListAppend(variables.wheels.query.group, $listClean(arguments.properties)) />
	<cfreturn this />
</cffunction>

<cffunction name="limit" returntype="component" output="false" access="public">
	<cfargument name="value" type="numeric" required="true" />
	<cfset variables.wheels.query.limit = arguments.value />
	<cfreturn this />
</cffunction>

<cffunction name="offset" returntype="component" output="false" access="public">
	<cfargument name="value" type="numeric" required="true" />
	<cfset variables.wheels.query.offset = arguments.value />
	<cfreturn this />
</cffunction>

<cffunction name="where" returntype="component" output="false" access="public">
	<cfargument name="property" type="string" required="false" default="" />
	<cfreturn $registerOperation(type="where", argumentCollection=arguments, container=variables.wheels.query.where) />
</cffunction>

<cffunction name="and" returntype="component" output="false" access="public">
	<cfargument name="property" type="string" required="false" default="" />
	<cfreturn $registerOperation(type="and", argumentCollection=arguments, container=variables.wheels.query.where) />
</cffunction>

<cffunction name="or" returntype="component" output="false" access="public">
	<cfargument name="property" type="string" required="false" default="" />
	<cfreturn $registerOperation(type="or", argumentCollection=arguments, container=variables.wheels.query.where) />
</cffunction>

<cffunction name="$registerOperation" returntype="component" output="false" access="public">
	<cfargument name="type" type="string" required="true" />
	<cfargument name="property" type="string" required="true" />
	<cfargument name="container" type="array" required="true" />
	<cfargument name="sql" type="string" required="false" default="" />
	<cfscript>
		var loc = {};
		loc.exclusionList = "type,property,container,#ArrayToList(variables.wheels.class.operators)#";
		
		if (Len(arguments.property) || Len(arguments.sql))
		{
			// make sure we have an operator and value
			for (loc.item in arguments)
			{
				if (ListFindNoCase(loc.exclusionList, loc.item))
				{
					if (FindNoCase("not", loc.item))
					{
						loc.item = LCase(ReplaceNoCase(loc.item, "not", ""));
						arguments.negate = true;
					}
					arguments.operator = loc.item;
					arguments.value = arguments[loc.item];
					StructDelete(arguments, loc.item);
					break;
				}
			}
			
			if (StructKeyExists(arguments, "operator") && StructKeyExists(arguments, "value"))
			{
				if (application.wheels.showErrorInformation && ListFindNoCase("or,and", arguments.type) && !ArrayLen(arguments.container))
					$throw(type="Wheels.IncorrectQueryMethodChaining", message="The `where`method must be called before `or` or `and`.");
				arguments.container = $invoke(componentReference=variables, method="$#loc.operation#Operation", argumentCollection=arguments);
			}
			else
			{
				$throw(type="Wheels.OperationNotFound", message="Wheels could not find an operation. Please use any of these `#ArrayToList(variables.wheels.class.operators)#`.");
			}
		}
		
		// loop through the properties and add in our auto eql clauses
		for (loc.item in arguments)
			if (!ListFindNoCase(loc.exclusionList, loc.item))
				arguments.container = $registerOperation(type="and", property=loc.item, eql=arguments[loc.item], container=arguments.container);
	</cfscript>
	<cfreturn this />
</cffunction>

<cffunction name="$eqlOperation" returntype="array" access="public" output="false">
	<cfreturn $addOperation(argumentCollection=arguments) />
</cffunction>

<cffunction name="$greaterThanOperation" returntype="array" access="public" output="false">
	<cfreturn $addOperation(argumentCollection=arguments) />
</cffunction>

<cffunction name="$greaterThanEqlOperation" returntype="array" access="public" output="false">
	<cfreturn $addOperation(argumentCollection=arguments) />
</cffunction>

<cffunction name="$lessThanOperation" returntype="array" access="public" output="false">
	<cfreturn $addOperation(argumentCollection=arguments) />
</cffunction>

<cffunction name="$lessThanEqlOperation" returntype="array" access="public" output="false">
	<cfreturn $addOperation(argumentCollection=arguments) />
</cffunction>

<cffunction name="$inOperation" returntype="array" access="public" output="false">
	<cfset arguments.value = $ensureArray(arguments.value) />
	<cfreturn $addOperation(argumentCollection=arguments) />
</cffunction>

<cffunction name="$betweenOperation" returntype="array" access="public" output="false">
	<cfset arguments.value = $ensureArray(argumentCollection=arguments, length=2) />
	<cfreturn $addOperation(argumentCollection=arguments) />
</cffunction>

<cffunction name="$regexOperation" returntype="array" access="public" output="false">
	<!--- TODO: call model adapter to make sure we can do regex operations with the underlying storage device --->
	<cfreturn $addOperation(argumentCollection=arguments) />
</cffunction>

<cffunction name="$isNullOperation" returntype="array" access="public" output="false">
	<cfscript>
		if (IsBoolean(arguments.value) && !arguments.value)
			arguments.negate = true;
		arguments.value = "";
		arguments.container = $addOperation(argumentCollection=arguments);
	</cfscript>
	<cfreturn arguments.container />
</cffunction>

<cffunction name="$sqlOperation" returntype="array" access="public" output="false">
	<cfreturn $addOperation(argumentCollection=arguments) />
</cffunction>

<cffunction name="$ensureArray" returntype="array" access="public" output="false">
	<cfargument name="value" type="any" required="true" />
	<cfargument name="length" type="numeric" required="false" default="0" />
	<cfscript>
		if (IsSimpleValue(arguments.value))
			arguments.value = ListToArray($listClean(arguments.value));
		
		if (arguments.length gt 0 && ArrayLen(arguments.value) != arguments.length)
			$throw(type="Wheels.InvalidQueryPropertyValue", message="The value provided for the property `#arguments.property#` must be a list or array with exactly `#arguments.length#` values.");
	</cfscript>
	<cfreturn arguments.value />
</cffunction>

<cffunction name="$addOperation" returntype="array" access="public" output="false">
	<cfscript>
		var loc = {};
		ArrayAppend(arguments.container, StructNew());
		loc.length = ArrayLen(arguments.container);
		arguments.container[loc.length].type = arguments.type;
		if (Len(arguments.property))
			arguments.container[loc.length].property = arguments.property;
		else if (Len(arguments.sql))
			arguments.container[loc.length].sql = arguments.sql;
		arguments.container[loc.length].operation = loc.operation;
		arguments.container[loc.length].value = loc.value;
		arguments.container[loc.length].negate = false;
		if (StructKeyExists(arguments, "negate") && IsBoolean(arguments.negate) && arguments.negate)
			arguments.container[loc.length].negate = true;
	</cfscript>
	<cfreturn arguments.container />
</cffunction>

<cffunction name="clearQuery" returntype="component" access="public" output="false">
	<cfscript>
		variables.wheels.query = {};
		variables.wheels.query.distinct = false;
		variables.wheels.query.select = "";
		variables.wheels.query.include = "";
		variables.wheels.query.where = [];
		variables.wheels.query.group = "";
		variables.wheels.query.order = [];
		variables.wheels.query.having = [];
		variables.wheels.query.offset = -1;
		variables.wheels.query.limit = -1;
	</cfscript>
	<cfreturn this />
</cffunction>

