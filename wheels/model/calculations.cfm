<!--- PUBLIC MODEL CLASS METHODS --->

<cffunction name="average" returntype="any" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="where" type="string" required="false" default="">
	<cfargument name="include" type="string" required="false" default="">
	<cfargument name="distinct" type="boolean" required="false">
	<cfargument name="parameterize" type="any" required="false">
	<cfargument name="ifNull" type="any" required="false">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false">
	<cfargument name="group" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="average", args=arguments);
		arguments.type = "AVG";
		if (StructKeyExists(arguments, "group"))
		{
			loc.rv = $calculate(argumentCollection=arguments);
		}
		else
		{
			if (ListFindNoCase("cf_sql_integer,cf_sql_bigint,cf_sql_smallint,cf_sql_tinyint", variables.wheels.class.properties[arguments.property].type))
			{
				// this is an integer column so we get all the values from the database and do the calculation in ColdFusion since we can't run a query to get the average value without type casting it
				loc.values = findAll(select=arguments.property, where=arguments.where, include=arguments.include, parameterize=arguments.parameterize, includeSoftDeletes=arguments.includeSoftDeletes);
				loc.values = ListToArray(Evaluate("ValueList(loc.values.#arguments.property#)"));
				loc.rv = arguments.ifNull;
				if (!ArrayIsEmpty(loc.values))
				{
					if (arguments.distinct)
					{
						loc.tempValues = {};
						loc.iEnd = ArrayLen(loc.values);
						for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
						{
							StructInsert(loc.tempValues, loc.values[loc.i], loc.values[loc.i], true);
						}
						loc.values = ListToArray(StructKeyList(loc.tempValues));
					}
					loc.rv = ArrayAvg(loc.values);
				}
			}
			else
			{
				// if the column's type is a float or similar we can run an AVG type query since it will always return a value of the same type as the column
				loc.rv = $calculate(argumentCollection=arguments);

				// we convert the result to a string so that it is the same as what would happen if you calculate an average in ColdFusion code (like we do for integers in this function for example)
				loc.rv = JavaCast("string", loc.rv);
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="count" returntype="any" access="public" output="false">
	<cfargument name="where" type="string" required="false" default="">
	<cfargument name="include" type="string" required="false" default="">
	<cfargument name="parameterize" type="any" required="false">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false">
	<cfargument name="group" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="count", args=arguments);
		arguments.type = "COUNT";
		arguments.property = ListFirst(primaryKey());
		if (Len(arguments.include))
		{
			arguments.distinct = true;
		}
		else
		{
			arguments.distinct = false;
		}
		loc.rv = $calculate(argumentCollection=arguments);
		if (!StructKeyExists(arguments, "group") && !IsNumeric(loc.rv))
		{
			loc.rv = 0;
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="maximum" returntype="any" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="where" type="string" required="false" default="">
	<cfargument name="include" type="string" required="false" default="">
	<cfargument name="parameterize" type="any" required="false">
	<cfargument name="ifNull" type="any" required="false">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false">
	<cfargument name="group" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="maximum", args=arguments);
		arguments.type = "MAX";
		loc.rv = $calculate(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="minimum" returntype="any" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="where" type="string" required="false" default="">
	<cfargument name="include" type="string" required="false" default="">
	<cfargument name="parameterize" type="any" required="false">
	<cfargument name="ifNull" type="any" required="false">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false">
	<cfargument name="group" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="minimum", args=arguments);
		arguments.type = "MIN";
		loc.rv = $calculate(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<cffunction name="sum" returntype="any" access="public" output="false">
	<cfargument name="property" type="string" required="true">
	<cfargument name="where" type="string" required="false" default="">
	<cfargument name="include" type="string" required="false" default="">
	<cfargument name="distinct" type="boolean" required="false">
	<cfargument name="parameterize" type="any" required="false">
	<cfargument name="ifNull" type="any" required="false">
	<cfargument name="includeSoftDeletes" type="boolean" required="false" default="false">
	<cfargument name="group" type="string" required="false">
	<cfscript>
		var loc = {};
		$args(name="sum", args=arguments);
		arguments.type = "SUM";
		loc.rv = $calculate(argumentCollection=arguments);
	</cfscript>
	<cfreturn loc.rv>
</cffunction>

<!--- PRIVATE METHODS --->

<cffunction name="$calculate" returntype="any" access="public" output="false">
	<cfargument name="type" type="string" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="where" type="string" required="true">
	<cfargument name="include" type="string" required="true">
	<cfargument name="parameterize" type="any" required="true">
	<cfargument name="distinct" type="boolean" required="false" default="false">
	<cfargument name="ifNull" type="any" required="false" default="">
	<cfargument name="includeSoftDeletes" type="boolean" required="true">
	<cfargument name="group" type="string" required="false">
	<cfscript>
		var loc = {};

		// start the select string with the type (`SUM`, `COUNT` etc)
		arguments.select = "#arguments.type#(";

		// add the DISTINCT keyword if necessary (generally used for `COUNT` operations when associated tables are joined in the query, means we'll only count the unique primary keys on the current model)
		if (arguments.distinct)
		{
			arguments.select &= "DISTINCT ";
		}

		// create a list of columns for the `SELECT` clause either from regular properties on the model or calculated ones
		loc.properties = "";
		loc.iEnd = ListLen(arguments.property);
		for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
		{
			loc.item = Trim(ListGetAt(arguments.property, loc.i));
			if (ListFindNoCase(variables.wheels.class.propertyList, loc.item))
			{
				loc.properties = ListAppend(loc.properties, tableName() & "." & variables.wheels.class.properties[loc.item].column);
			}
			else if (ListFindNoCase(variables.wheels.class.calculatedPropertyList, loc.item))
			{
				loc.properties = ListAppend(loc.properties, variables.wheels.class.calculatedProperties[loc.item].sql);
			}
		}
		arguments.select &= loc.properties;

		// alias the result with `AS`, this means that Wheels will not try and change the string (which is why we have to add the table name above since it won't be done automatically)
		loc.alias = LCase(arguments.type);
		loc.alias = Replace(Replace(Replace(loc.alias, "avg", "average"), "min", "minimum"), "max", "maximum");
		if (arguments.type != "count")
		{
			loc.alias = arguments.property & loc.alias;
		}
		arguments.select &= ") AS " & loc.alias;

		if (StructKeyExists(arguments, "group"))
		{
			if (ListFindNoCase(variables.wheels.class.calculatedPropertyList, arguments.group))
			{
				arguments.select = ListAppend(arguments.select, variables.wheels.class.calculatedProperties[arguments.group].sql & " AS " & arguments.group);
			}
			else
			{
				arguments.select = ListAppend(arguments.select, tableName() & "." & arguments.group);
			}
		}

		// call `findAll` with `select`, `where`, `group`, `parameterize` and `include` but delete all other arguments
		StructDelete(arguments, "type");
		StructDelete(arguments, "property");
		StructDelete(arguments, "distinct");

		// since we don't return any records for calculation methods we want to skip the callbacks
		arguments.callbacks = false;

		loc.rv = findAll(argumentCollection=arguments);
		if (!StructKeyExists(arguments, "group"))
		{
			// when not grouping by something we just return the value itself
			loc.rv = loc.rv[loc.alias];
			if (!Len(loc.rv) && Len(arguments.ifNull))
			{
				loc.rv = arguments.ifNull;
			}
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>