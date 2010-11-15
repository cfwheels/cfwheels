<cffunction name="distinct" returntype="component" output="false" access="public">
	<cfset variables.wheels.instance.query.distinct = true>
	<cfreturn this />
</cffunction>

<cffunction name="select" returntype="component" output="false" access="public">
	<cfargument name="properties" type="string" required="true" />
	<cfset variables.wheels.instance.query.select = ListAppend(variables.wheels.instance.query.select, $listClean(arguments.properties)) />
	<cfreturn this />
</cffunction>

<cffunction name="include" returntype="component" output="false" access="public">
	<cfargument name="associations" type="string" required="false" default="" />
	<cfscript>
		arguments.associations = $listClean(arguments.associations);
		// we could also have an association argument
		if (!Len(arguments.associations) && StructKeyExists(arguments, "association"))
			arguments.associations = $listClean(arguments.association);
		variables.wheels.instance.query.include = ListAppend(variables.wheels.instance.query.include, arguments.associations);
	</cfscript>
	<cfreturn this />
</cffunction>

<cffunction name="where" returntype="component" output="false" access="public">
	<cfargument name="property" type="string" required="false" default="" />
	<cfset variables.wheels.instance.query.where = $registerOperation(argumentCollection=arguments, type="where", container=variables.wheels.instance.query.where)>
	<cfreturn this />
</cffunction>

<cffunction name="and" returntype="component" output="false" access="public">
	<cfargument name="property" type="string" required="false" default="" />
	<cfset variables.wheels.instance.query.where = $registerOperation(argumentCollection=arguments, type="and", container=variables.wheels.instance.query.where)>
	<cfreturn this />
</cffunction>

<cffunction name="or" returntype="component" output="false" access="public">
	<cfargument name="property" type="string" required="false" default="" />
	<cfset variables.wheels.instance.query.where = $registerOperation(argumentCollection=arguments, type="or", container=variables.wheels.instance.query.where)>
	<cfreturn this />
</cffunction>

<cffunction name="group" returntype="component" output="false" access="public">
	<cfargument name="properties" type="string" required="true" />
	<cfset variables.wheels.instance.query.group = ListAppend(variables.wheels.instance.query.group, $listClean(arguments.properties)) />
	<cfreturn this />
</cffunction>

<cffunction name="order" returntype="component" output="false" access="public">
	<cfargument name="property" type="string" required="true" />
	<cfargument name="direction" type="string" required="false" default="ASC" />
	<cfscript>
		var loc = {};
		ArrayAppend(variables.wheels.instance.query.order, StructNew());
		loc.length = ArrayLen(variables.wheels.instance.query.order);
		variables.wheels.instance.query.order[loc.length].property = arguments.property;
		variables.wheels.instance.query.order[loc.length].direction = UCase(arguments.direction);
	</cfscript>
	<cfreturn this />
</cffunction>

<cffunction name="page" returntype="component" output="false" access="public">
	<cfargument name="value" type="numeric" required="true" />
	<cfset variables.wheels.instance.query.page = arguments.value />
	<cfreturn this />
</cffunction>

<cffunction name="perPage" returntype="component" output="false" access="public">
	<cfargument name="value" type="numeric" required="true" />
	<cfset variables.wheels.instance.query.perpage = arguments.value />
	<cfreturn this />
</cffunction>

<cffunction name="maxRows" returntype="component" output="false" access="public">
	<cfargument name="value" type="numeric" required="true" />
	<cfset variables.wheels.instance.query.maxrows = arguments.value />
	<cfreturn this />
</cffunction>

<cffunction name="$registerOperation" returntype="array" output="false" access="public">
	<cfargument name="type" type="string" required="true" />
	<cfargument name="property" type="string" required="true" />
	<cfargument name="container" type="array" required="true" />
	<cfscript>
		var loc = {};
		loc.operationList = ArrayToList(variables.wheels.class.operations);
		loc.exclusionList = ListPrepend(loc.operationList, "type,property,container,value,operator,negate");
		
		if (Len(arguments.property) || StructKeyExists(arguments, "sql"))
		{
			// make sure we have an operator and value
			for (loc.item in arguments)
			{
				if (ListFindNoCase(loc.operationList, loc.item))
				{
					arguments.value = arguments[loc.item];
					if (FindNoCase("not", loc.item))
					{
						loc.item = LCase(ReplaceNoCase(loc.item, "not", ""));
						arguments.negate = true;
					}
					arguments.operator = loc.item;
					StructDelete(arguments, loc.item);
					break;
				}
			}
			
			if (StructKeyExists(arguments, "operator") && StructKeyExists(arguments, "value"))
			{
				if (application.wheels.showErrorInformation && ListFindNoCase("or,and", arguments.type) && !ArrayLen(arguments.container))
					$throw(type="Wheels.IncorrectQueryMethodChaining", message="The `where`method must be called before `or` or `and`.");
				arguments.container = $invoke(method="$#arguments.operator#Operation", argumentCollection=arguments);
			}
			else if (StructKeyExists(arguments, "operator"))
			{
				$throw(type="Wheels.OperationNotValid", message="The operation `#arguments.operator#` is not valid. Please use any of these `#ArrayToList(variables.wheels.class.operators)#`.");
			}
			else
			{
				$throw(type="Wheels.OperationNotFound", message="An operation could not be found. Please use any of these `#ArrayToList(variables.wheels.class.operators)#`.");
			}
		}
		// loop through the properties and add in our auto eql clauses
		if (!StructKeyExists(arguments, "$auto"))
		{
			// should we try to keep the order of how the arguments were passed in here??? right now coldfusion changes the order to a text ordering
			for (loc.item in arguments)
			{
				if (!ListFindNoCase(loc.exclusionList, loc.item))
				{
					loc.type = "and";
					if (arguments.type == "where" && ArrayIsEmpty(arguments.container))
						loc.type = "where";
					if (!ListFindNoCase(loc.exclusionList, loc.item))
						arguments.container = $registerOperation(type=loc.type, property=loc.item, eql=arguments[loc.item], container=arguments.container, $auto=true);
				}
			}
		}
	</cfscript>
	<cfreturn arguments.container />
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

<cffunction name="$nullOperation" returntype="array" access="public" output="false">
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
		arguments.container[loc.length].operation = arguments.operator;
		arguments.container[loc.length].value = arguments.value;
		arguments.container[loc.length].negate = false;
		if (StructKeyExists(arguments, "negate") && IsBoolean(arguments.negate) && arguments.negate)
			arguments.container[loc.length].negate = true;
	</cfscript>
	<cfreturn arguments.container />
</cffunction>

<cffunction name="clearQuery" returntype="component" access="public" output="false">
	<cfscript>
		variables.wheels.instance.query = {};
		variables.wheels.instance.query.distinct = false;
		variables.wheels.instance.query.select = "";
		variables.wheels.instance.query.include = "";
		variables.wheels.instance.query.where = [];
		variables.wheels.instance.query.group = "";
		variables.wheels.instance.query.order = [];
		variables.wheels.instance.query.having = [];
		variables.wheels.instance.query.page = 0;
		variables.wheels.instance.query.perPage = 0;
		variables.wheels.instance.query.maxRows = -1;
	</cfscript>
	<cfreturn this />
</cffunction>

<cffunction name="query" returntype="struct" access="public" output="false">
	<cfreturn variables.wheels.instance.query />
</cffunction>

