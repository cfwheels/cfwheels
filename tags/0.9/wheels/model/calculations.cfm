<cffunction name="average" returntype="numeric" access="public" output="false" hint="Calculates the average value for a given property. Uses the SQL function AVG.">
	<cfargument name="property" type="string" required="true" hint="Name of the property to calculate the average for">
	<cfargument name="where" type="string" required="false" default="" hint="A SQL fragment such as lastName LIKE 'A%' for example">
	<cfargument name="include" type="string" required="false" default="" hint="Any associations that needs to be included in the query">
	<cfargument name="distinct" type="boolean" required="false" default="false" hint="When true, AVG will be performed only on each unique instance of a value, regardless of how many times the value occurs">
	<cfscript>
		arguments.type = "AVG";
	</cfscript>
	<cfreturn $calculate(argumentCollection=arguments)>
</cffunction>

<cffunction name="count" returntype="numeric" access="public" output="false" hint="Returns the number of rows that match the arguments (or all rows if no arguments are passed in). Uses the SQL function COUNT.">
	<cfargument name="where" type="string" required="false" default="" hint="A SQL fragment such as admin=1 for example">
	<cfargument name="include" type="string" required="false" default="" hint="Any associations that needs to be included in the query">
	<cfscript>
		if (Len(arguments.include))
		{
			arguments.distinct = true;
			arguments.property = variables.wheels.class.keys;
		}
		else
		{
			arguments.distinct = false;
			arguments.property = "*";
		}
		arguments.type = "COUNT";
	</cfscript>
	<cfreturn $calculate(argumentCollection=arguments)>
</cffunction>

<cffunction name="maximum" returntype="numeric" access="public" output="false" hint="Calculates the maximum value for a given property. Uses the SQL function MAX.">
	<cfargument name="property" type="string" required="true" hint="Name of the property to get the highest value for (has to be a property of a numeric data type)">
	<cfargument name="where" type="string" required="false" default="" hint="A SQL fragment such as categoryId=4 for example">
	<cfargument name="include" type="string" required="false" default="" hint="Any associations that needs to be included in the query">
	<cfscript>
		arguments.type = "MAX";
	</cfscript>
	<cfreturn $calculate(argumentCollection=arguments)>
</cffunction>

<cffunction name="minimum" returntype="numeric" access="public" output="false" hint="Calculates the maximum value for a given property. Uses the SQL function MIN.">
	<cfargument name="property" type="string" required="true" hint="Name of the property to get the lowest value for (has to be a property of a numeric data type)">
	<cfargument name="where" type="string" required="false" default="" hint="A SQL fragment such as lastName LIKE 'A%' for example">
	<cfargument name="include" type="string" required="false" default="" hint="Any associations that needs to be included in the query">
	<cfscript>
		arguments.type = "MIN";
	</cfscript>
	<cfreturn $calculate(argumentCollection=arguments)>
</cffunction>

<cffunction name="sum" returntype="numeric" access="public" output="false" hint="Calculates the sum of values for a given property. Uses the SQL function SUM.">
	<cfargument name="property" type="string" required="true" hint="Name of the property to get the sum for (has to be a property of a numeric data type)">
	<cfargument name="where" type="string" required="false" default="" hint="A SQL fragment such as lastName LIKE 'A%' for example">
	<cfargument name="include" type="string" required="false" default="" hint="Any associations that needs to be included in the query">
	<cfargument name="distinct" type="boolean" required="false" default="false" hint="When true, SUM returns the sum of unique values only">
	<cfscript>
		arguments.type = "SUM";
	</cfscript>
	<cfreturn $calculate(argumentCollection=arguments)>
</cffunction>

<cffunction name="$calculate" returntype="numeric" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="where" type="string" required="false" default="">
	<cfargument name="include" type="string" required="false" default="">
	<cfargument name="distinct" type="boolean" required="false" default="false">
	<cfscript>
		var loc = {};
		arguments.select = "#arguments.type#(";
		if (arguments.distinct)
			arguments.select = arguments.select & "DISTINCT ";
		if (arguments.property IS "*")
		{
			arguments.select = arguments.select & arguments.property;
		}
		else
		{
			loc.properties = "";
			loc.iEnd = ListLen(arguments.property);
			for (loc.i=1; loc.i LTE loc.iEnd; loc.i=loc.i+1)
			{
				loc.iItem = Trim(ListGetAt(arguments.property, loc.i));
				loc.properties = ListAppend(loc.properties, variables.wheels.class.tableName & "." & variables.wheels.class.properties[loc.iItem].column);
			}
			arguments.select = arguments.select & loc.properties;
		}
		arguments.select = arguments.select & ") AS result";
		StructDelete(arguments, "type");
		StructDelete(arguments, "property");
		loc.query = findAll(argumentCollection=arguments);
		if (Len(loc.query.result))
			loc.returnValue = loc.query.result;
		else
			loc.returnValue = 0;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>