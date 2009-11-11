<!--- PUBLIC MODEL CLASS METHODS --->

<cffunction name="average" returntype="any" access="public" output="false" hint="Calculates the average value for a given property. Uses the SQL function `AVG`. If no records can be found to perform the calculation on, a blank string is returned."
	examples=
	'
		<!--- Get the average salary for all employees --->
		<cfset avgSalary = model("employee").average("salary")>
	'
	categories="model-class,statistics" chapters="column-statistics" functions="count,maximum,minimum,sum">
	<cfargument name="property" type="string" required="true" hint="Name of the property to calculate the average for.">
	<cfargument name="where" type="string" required="false" default="" hint="An SQL fragment such as `lastName LIKE 'A%'` for example.">
	<cfargument name="include" type="string" required="false" default="" hint="Any associations that need to be included in the query.">
	<cfargument name="distinct" type="boolean" required="false" default="#application.wheels.functions.average.distinct#" hint="When `true`, `AVG` will be performed only on each unique instance of a value, regardless of how many times the value occurs.">
	<cfscript>
		var loc = {};
		if (ListFindNoCase("cf_sql_integer,cf_sql_bigint,cf_sql_smallint,cf_sql_tinyint", variables.wheels.class.properties[arguments.property].type))
		{
			// this is an integer column so we get all the values from the database and do the calculation in ColdFusion since we can't run a query to get the average value without type casting it
			loc.values = findAll(select=arguments.property, where=arguments.where, include=arguments.include);
			loc.totalRecords = 0;
			loc.total = 0;
			loc.done = "";
			for (loc.i=1; loc.i <= loc.values.recordCount; loc.i++)
			{
				if (!arguments.distinct || !ListFind(loc.done, loc.value))
				{
					loc.totalRecords++;
					loc.value = val(loc.values[arguments.property][loc.i]);
					loc.total = loc.total + loc.value;
					loc.done = ListAppend(loc.done, loc.value);
				}
			}
			loc.returnValue = loc.total / loc.totalRecords;
		}
		else
		{
			// if the column's type is a float or similar we can run an AVG type query since it will always return a value of the same type as the column
			arguments.type = "AVG";
			loc.returnValue = $calculate(argumentCollection=arguments);
			// we convert the result to a string so that it is the same as what would happen if you calculate an average in ColdFusion code (like we do for integers in this function for example)
			loc.returnValue = JavaCast("string", loc.returnValue);
		}
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>

<cffunction name="count" returntype="numeric" access="public" output="false" hint="Returns the number of rows that match the arguments (or all rows if no arguments are passed in). Uses the SQL function `COUNT`. If no records can be found to perform the calculation on, `0` is returned."
	examples=
	'
		<!--- Count how many authors there are in the table --->
		<cfset authorCount = model("author").count()>

		<!--- Count how many authors whose last name starts with "A" there are --->
		<cfset authorOnACount = model("author").count(where="lastName LIKE ''A%''")>

		<!--- Count how many authors that have written books starting on "A" --->
		<cfset authorWithBooksOnACount = model("author").count(include="books", where="title LIKE ''A%''")>

		<!--- Count the number of comments on a specific post (a `hasMany` association from `post` to `comment` is required) --->
		<!--- The `commentCount` method will call `model("comment").count(where="postId=##post.id##")` internally --->
		<cfset aPost = model("post").findByKey(params.postId)>
		<cfset amount = aPost.commentCount()>
	'
	categories="model-class,statistics" chapters="column-statistics,associations" functions="average,hasMany,maximum,minimum,sum">
	<cfargument name="where" type="string" required="false" default="" hint="See documentation for @average.">
	<cfargument name="include" type="string" required="false" default="" hint="See documentation for @average.">
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

<cffunction name="maximum" returntype="any" access="public" output="false" hint="Calculates the maximum value for a given property. Uses the SQL function `MAX`. If no records can be found to perform the calculation on, a blank string is returned."
	examples=
	'
		<!--- Get the amount of the highest salary for all employees --->
		<cfset highestSalary = model("employee").maximum("salary")>
	'
	categories="model-class,statistics" chapters="column-statistics" functions="average,count,minimum,sum">
	<cfargument name="property" type="string" required="true" hint="Name of the property to get the highest value for (has to be a property of a numeric data type).">
	<cfargument name="where" type="string" required="false" default="" hint="See documentation for @average.">
	<cfargument name="include" type="string" required="false" default="" hint="See documentation for @average.">
	<cfscript>
		arguments.type = "MAX";
	</cfscript>
	<cfreturn $calculate(argumentCollection=arguments)>
</cffunction>

<cffunction name="minimum" returntype="any" access="public" output="false" hint="Calculates the minimum value for a given property. Uses the SQL function `MIN`. If no records can be found to perform the calculation on, a blank string is returned."
	examples=
	'
		<!--- Get the amount of the lowest salary for all employees --->
		<cfset lowestSalary = model("employee").minimum("salary")>
	'
	categories="model-class,statistics" chapters="column-statistics" functions="average,count,maximum,sum">
	<cfargument name="property" type="string" required="true" hint="Name of the property to get the lowest value for (has to be a property of a numeric data type).">
	<cfargument name="where" type="string" required="false" default="" hint="See documentation for @average.">
	<cfargument name="include" type="string" required="false" default="" hint="See documentation for @average.">
	<cfscript>
		arguments.type = "MIN";
	</cfscript>
	<cfreturn $calculate(argumentCollection=arguments)>
</cffunction>

<cffunction name="sum" returntype="any" access="public" output="false" hint="Calculates the sum of values for a given property. Uses the SQL function `SUM`. If no records can be found to perform the calculation on, `0` is returned."
	examples=
	'
		<!--- Get the sum of all salaries --->
		<cfset allSalaries = model("employee").sum(property="salary")>

		<!--- Get the sum of all salaries for employees in Australia --->
		<cfset allAustralianSalaries = model("employee").sum(property="salary", include="country", where="name=''Australia''")>
	'
	categories="model-class,statistics" chapters="column-statistics" functions="average,count,maximum,minimum">
	<cfargument name="property" type="string" required="true" hint="Name of the property to get the sum for (has to be a property of a numeric data type).">
	<cfargument name="where" type="string" required="false" default="" hint="See documentation for @average.">
	<cfargument name="include" type="string" required="false" default="" hint="See documentation for @average.">
	<cfargument name="distinct" type="boolean" required="false" default="#application.wheels.functions.sum.distinct#" hint="When `true`, `SUM` returns the sum of unique values only.">
	<cfscript>
		var returnValue = "";
		arguments.type = "SUM";
		returnValue = $calculate(argumentCollection=arguments);
	</cfscript>
	<cfreturn returnValue>
</cffunction>

<!--- PRIVATE MODEL CLASS METHODS --->

<cffunction name="$calculate" returntype="any" access="public" output="false" hint="Creates the query that needs to be run for all of the above methods.">
	<cfargument name="type" type="string" required="true">
	<cfargument name="property" type="string" required="true">
	<cfargument name="where" type="string" required="false" default="">
	<cfargument name="include" type="string" required="false" default="">
	<cfargument name="distinct" type="boolean" required="false" default="false">
	<cfscript>
		var loc = {};

		// start the select string with the type (`SUM`, `COUNT` etc)
		arguments.select = "#arguments.type#(";

		// add the DISTINCT keyword if necessary (generally used for `COUNT` operations when associated tables are joined in the query, means we'll only count the unique primary keys on the current model)
		if (arguments.distinct)
			arguments.select = arguments.select & "DISTINCT ";

		// create a list of columns for the `SELECT` clause (unless just `*` was passed in) either from regular properties on the model or calculated ones
		if (arguments.property == "*")
		{
			arguments.select = arguments.select & arguments.property;
		}
		else
		{
			loc.properties = "";
			loc.iEnd = ListLen(arguments.property);
			for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
			{
				loc.iItem = Trim(ListGetAt(arguments.property, loc.i));
				if (ListFindNoCase(variables.wheels.class.propertyList, loc.iItem))
					loc.properties = ListAppend(loc.properties, variables.wheels.class.tableName & "." & variables.wheels.class.properties[loc.iItem].column);
				else if (ListFindNoCase(variables.wheels.class.calculatedPropertyList, loc.iItem))
					loc.properties = ListAppend(loc.properties, variables.wheels.class.calculatedProperties[loc.iItem].sql);
			}
			arguments.select = arguments.select & loc.properties;
		}

		// alias the result with `AS`, this means that Wheels will not try and change the string (which is why we have to add the table name above since it won't be done automatically)
		arguments.select = arguments.select & ") AS result";

		// call `findAll` with `select`, `where` and `include` but delete all other arguments
		StructDelete(arguments, "type");
		StructDelete(arguments, "property");
		StructDelete(arguments, "distinct");
		loc.query = findAll(argumentCollection=arguments);
		loc.returnValue = loc.query.result;
	</cfscript>
	<cfreturn loc.returnValue>
</cffunction>